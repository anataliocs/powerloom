#!/bin/bash


cp config/projects.example.json config/projects.json
cp config/settings.example.json config/settings.json

export namespace="${NAMESPACE:-namespace_hash}"
export ipfs_url="${IPFS_URL:-}"
export ipfs_api_key="${IPFS_API_KEY:-}"
export ipfs_api_secret="${IPFS_API_SECRET:-}"
export web3_storage_token="${WEB3_STORAGE_TOKEN:-}"
export relayer_host="${RELAYER_HOST:-https://relayer-prod1d.powerloom.io}"

export slack_reporting_url="${SLACK_REPORTING_URL:-}"
export powerloom_reporting_url="${POWERLOOM_REPORTING_URL:-}"

# If IPFS_URL is empty, clear IPFS API key and secret
if [ -z "$IPFS_URL" ]; then
    ipfs_api_key=""
    ipfs_api_secret=""
fi

sed -i'.backup' "s#relevant-namespace#$namespace#" config/settings.json

sed -i'.backup' "s#account-address#$SIGNER_ACCOUNT_ADDRESS#" config/settings.json
sed -i'.backup' "s#slot-id#$SLOT_ID#" config/settings.json

sed -i'.backup' "s#https://rpc-url#$SOURCE_RPC_URL#" config/settings.json

sed -i'.backup' "s#https://prost-rpc-url#$PROST_RPC_URL#" config/settings.json

sed -i'.backup' "s#web3-storage-token#$web3_storage_token#" config/settings.json
sed -i'.backup' "s#ipfs-writer-url#$ipfs_url#" config/settings.json
sed -i'.backup' "s#ipfs-writer-key#$ipfs_api_key#" config/settings.json
sed -i'.backup' "s#ipfs-writer-secret#$ipfs_api_secret#" config/settings.json

sed -i'.backup' "s#ipfs-reader-url#$ipfs_url#" config/settings.json
sed -i'.backup' "s#ipfs-reader-key#$ipfs_api_key#" config/settings.json
sed -i'.backup' "s#ipfs-reader-secret#$ipfs_api_secret#" config/settings.json

sed -i'.backup' "s#protocol-state-contract#$PROTOCOL_STATE_CONTRACT#" config/settings.json

sed -i'.backup' "s#https://slack-reporting-url#$slack_reporting_url#" config/settings.json

sed -i'.backup' "s#https://powerloom-reporting-url#$powerloom_reporting_url#" config/settings.json

sed -i'.backup' "s#signer-account-private-key#$SIGNER_ACCOUNT_PRIVATE_KEY#" config/settings.json
sed -i'.backup' "s#https://relayer-url#$relayer_host#" config/settings.json
