from src import nft_erc721

PUG_URI = "QmVjnLPEiqjTovkjcjXufEoHKTj98eZX8b3adEH4STRA5i"
def deploy_nft():
    contract = nft_erc721.deploy()
    contract.mint(PUG_URI)
    token_URI = contract.tokenURI(0)
    print(token_URI)

def moccasin_main():
    deploy_nft()