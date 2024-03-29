from snapshotter.utils.default_logger import logger
from snapshotter.utils.rpc import RpcHelper
from web3 import Web3

from ..settings.config import settings as worker_settings
from .constants import current_node
from .constants import erc20_abi
from .constants import pair_contract_abi


helper_logger = logger.bind(module='Uniswap|Helpers')


def get_maker_pair_data(prop):
    prop = prop.lower()
    if prop.lower() == 'name':
        return 'Maker'
    elif prop.lower() == 'symbol':
        return 'MKR'
    else:
        return 'Maker'


async def get_pair(
    factory_contract_obj,
    token0,
    token1,
    rpc_helper: RpcHelper,
):

    tasks = [
        factory_contract_obj.functions.getPair(
            Web3.to_checksum_address(token0),
            Web3.to_checksum_address(token1),
        ),
    ]

    result = await rpc_helper.web3_call(tasks)
    pair = result[0]

    return pair


async def get_pair_metadata(
    pair_address,
    rpc_helper: RpcHelper,
):
    """
    returns information on the tokens contained within a pair contract - name, symbol, decimals of token0 and token1
    also returns pair symbol by concatenating {token0Symbol}-{token1Symbol}
    """
    try:
        pair_address = Web3.to_checksum_address(pair_address)
        if pair_address in worker_settings.metadata_cache:
            return worker_settings.metadata_cache[pair_address]

        pair_contract_obj = current_node['web3_client'].eth.contract(
            address=Web3.to_checksum_address(pair_address),
            abi=pair_contract_abi,
        )
        token0Addr, token1Addr = await rpc_helper.web3_call(
            [
                pair_contract_obj.functions.token0(),
                pair_contract_obj.functions.token1(),
            ],
        )

        # token0 contract
        token0 = current_node['web3_client'].eth.contract(
            address=Web3.to_checksum_address(token0Addr),
            abi=erc20_abi,
        )
        # token1 contract
        token1 = current_node['web3_client'].eth.contract(
            address=Web3.to_checksum_address(token1Addr),
            abi=erc20_abi,
        )
        tasks = list()

        # special case to handle maker token
        maker_token0 = None
        maker_token1 = None
        if Web3.to_checksum_address(
            worker_settings.contract_addresses.MAKER,
        ) == Web3.to_checksum_address(token0Addr):
            token0_name = get_maker_pair_data('name')
            token0_symbol = get_maker_pair_data('symbol')
            maker_token0 = True
        else:
            tasks.append(token0.functions.name())
            tasks.append(token0.functions.symbol())
        tasks.append(token0.functions.decimals())

        if Web3.to_checksum_address(
            worker_settings.contract_addresses.MAKER,
        ) == Web3.to_checksum_address(token1Addr):
            token1_name = get_maker_pair_data('name')
            token1_symbol = get_maker_pair_data('symbol')
            maker_token1 = True
        else:
            tasks.append(token1.functions.name())
            tasks.append(token1.functions.symbol())
        tasks.append(token1.functions.decimals())

        if maker_token1:
            [
                token0_name,
                token0_symbol,
                token0_decimals,
                token1_decimals,
            ] = await rpc_helper.web3_call(tasks)
        elif maker_token0:
            [
                token0_decimals,
                token1_name,
                token1_symbol,
                token1_decimals,
            ] = await rpc_helper.web3_call(tasks)
        else:
            [
                token0_name,
                token0_symbol,
                token0_decimals,
                token1_name,
                token1_symbol,
                token1_decimals,
            ] = await rpc_helper.web3_call(tasks)

        return {
            'token0': {
                'address': token0Addr,
                'name': token0_name,
                'symbol': token0_symbol,
                'decimals': token0_decimals,
            },
            'token1': {
                'address': token1Addr,
                'name': token1_name,
                'symbol': token1_symbol,
                'decimals': token1_decimals,
            },
            'pair': {
                'symbol': f'{token0_symbol}-{token1_symbol}',
            },
        }
    except Exception as err:
        # this will be retried in next cycle
        helper_logger.opt(exception=True).error(
            (
                f'RPC error while fetcing metadata for pair {pair_address},'
                f' error_msg:{err}'
            ),
        )
        raise err
