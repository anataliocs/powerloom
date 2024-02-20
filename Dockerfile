FROM nikolaik/python-nodejs:python3.10-nodejs18

ARG SOURCE_RPC_URL
ENV SOURCE_RPC_URL=$SOURCE_RPC_URL

ARG SIGNER_ACCOUNT_ADDRESS
ENV SIGNER_ACCOUNT_ADDRESS=$SIGNER_ACCOUNT_ADDRESS

ARG SIGNER_ACCOUNT_PRIVATE_KEY
ENV SIGNER_ACCOUNT_PRIVATE_KEY=$SIGNER_ACCOUNT_PRIVATE_KEY

ARG SLOT_ID
ENV SLOT_ID=$SLOT_ID

ARG RELAYER_HOST
ENV RELAYER_HOST=$RELAYER_HOST

ARG PROST_RPC_URL
ENV PROST_RPC_URL=$PROST_RPC_URL

ARG IPFS_URL
ENV IPFS_URL=$IPFS_URL

ARG IPFS_API_KEY
ENV IPFS_API_KEY=$IPFS_API_KEY

ARG PROTOCOL_STATE_CONTRACT
ENV PROTOCOL_STATE_CONTRACT=$PROTOCOL_STATE_CONTRACT

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

EXPOSE 8002

# Start the application using PM2
CMD bash -c "sh snapshotter_autofill.sh && sh init_docker.sh"