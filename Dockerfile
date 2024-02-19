FROM python:bookworm

ARG SOURCE_RPC_URL
ENV SOURCE_RPC_URL=$SOURCE_RPC_URL

ARG SIGNER_ACCOUNT_ADDRESS
ENV SIGNER_ACCOUNT_ADDRESS=$SIGNER_ACCOUNT_ADDRESS

ARG SIGNER_ACCOUNT_PRIVATE_KEY
ENV SIGNER_ACCOUNT_PRIVATE_KEY=$SIGNER_ACCOUNT_PRIVATE_KEY

ARG SLOT_ID
ENV SLOT_ID=$SLOT_ID

RUN groupadd --gid 1000 pn && useradd --uid 1000 --gid pn --shell /bin/bash --create-home pn
ENV POETRY_HOME=/usr/local

# Install nodejs and yarn
RUN NODE_VERSION="$(curl -fsSL https://nodejs.org/dist/latest/SHASUMS256.txt | head -n1 | awk '{ print $2}' | awk -F - '{ print $2}')" \
  ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    arm64) ARCH='arm64';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && for key in $(curl -sL https://raw.githubusercontent.com/nodejs/docker-node/HEAD/keys/node.keys); do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs
RUN corepack enable yarn
RUN \
  apt-get update && \
  apt-get upgrade -yqq && \
  pip install -U pip && pip install pipenv && \
  curl -sSL https://install.python-poetry.org | python - && \
  rm -rf /var/lib/apt/lists/*

# Set NODE_ENV environment variable
ENV NODE_ENV production

USER node

# Install the PM2 process manager for Node.js
RUN npm install pm2 -g

# Copy the application's dependencies files
COPY poetry.lock pyproject.toml ./

# Install the Python dependencies
RUN poetry install --no-dev --no-root

# Copy the rest of the application's files
COPY . .

# Make the shell scripts executable
RUN chmod +x ./snapshotter_autofill.sh ./init_docker.sh

# Start the application using PM2
CMD pm2 start pm2.config.js && pm2 logs --lines 100