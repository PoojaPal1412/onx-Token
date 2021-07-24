from brownie import ONX, accounts


def main():
    return ONX.deploy({'from': accounts[0]})
