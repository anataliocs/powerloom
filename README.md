## About

Run a Powerloom lite Node slot on Polygon POS on Spheron

If you don't already have one, (Create a Spheron account )[https://app.spheron.network/#/signup]

## Setup
There are multiple ways to set up the Snapshotter Lite Node. You can either use the Docker image or run it directly on your local machine.
However, it is recommended to use the Docker image as it is the easiest and most reliable way to set up the Snapshotter Lite Node.

### Using Docker

1. Run `build.sh` to start the snapshotter lite node:
   ```bash
   ./build.sh
   ```
   If you're a developer and want to play around with the code, instead of running `build.sh`, you can run the following command to start the snapshotter lite node:
   ```bash
   ./build-dev.sh
   ```

2. When prompted, enter `$SOURCE_RPC_URL`, `SIGNER_ACCOUNT_ADDRESS`, `SIGNER_ACCOUNT_PRIVATE_KEY` (only required for the first time), this will create a `.env` file in the root directory of the project.

3. This should start your snapshotter node and you should see something like this in your terminal logs
  ```bash
  snapshotter-lite_1  | 1|snapshotter-lite  | February 5, 2024 > 15:10:17 | INFO | Current block: 2208370| {'module': 'EventDetector'}
  snapshotter-lite_1  | 1|snapshotter-lite  | February 5, 2024 > 15:10:18 | DEBUG | Set source chain block time to 12.0| {'module': 'ProcessDistributor'}
  snapshotter-lite_1  | 1|snapshotter-lite  | February 5, 2024 > 15:10:20 | INFO | Snapshotter enabled: True| {'module': 'ProcessDistributor'}
  snapshotter-lite_1  | 1|snapshotter-lite  | February 5, 2024 > 15:10:20 | INFO | Snapshotter slot is set to 1| {'module': 'ProcessDistributor'}
  snapshotter-lite_1  | 1|snapshotter-lite  | February 5, 2024 > 15:10:20 | INFO | Snapshotter enabled: True| {'module': 'ProcessDistributor'}
  snapshotter-lite_1  | 1|snapshotter-lite  | February 5, 2024 > 15:10:21 | INFO | Snapshotter active: True| {'module': 'ProcessDistributor'}
  snapshotter-lite_1  | 0|core-api          | February 5, 2024 > 15:10:22 | INFO | 127.0.0.1:59776 - "GET /health HTTP/1.1" 200 | {} 
  ```
4. To stop the node, you can press `Ctrl+C` in the terminal where the node is running or `docker-compose down` in a new terminal window from the project directory.
