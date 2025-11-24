from interfaces import AggregatorV3Interface


@internal
def _get_eth_to_usd_rate(price_feed: AggregatorV3Interface, eth_amount: uint256) -> uint256:
    """
    Convert ETH to USD 
    """
    # ABI from interface above 
    price: int256 = staticcall price_feed.latestAnswer() # 8 decimal places,  staticcall to use external function without modifing anything in external contract
    eth_price: uint256 = convert(price, uint256) * (10 ** 10)
    eth_amount_usd: uint256 = eth_amount * eth_price // (1 * (10 **18)) # 1 x 10^18
    return eth_amount_usd