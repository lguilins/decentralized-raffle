const {
    networkConfig,
    developmentChains,
    VERIFICATION_BLOCK_CONFIRMATIONS,
} = require("../helper-hardhat-config")

const chainId = 4

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    const args = [
        networkConfig[chainId]["raffleEntranceFee"],
        networkConfig[chainId]["keepersUpdateInterval"],
        networkConfig[chainId]["vrfCoordinatorV2"],
        networkConfig[chainId]["gasLane"],
        networkConfig[chainId]["callbackGasLimit"],
        networkConfig[chainId]["subscriptionId"]
    ]

    const waitBlockConfirmations = developmentChains.includes(network.name)
        ? 1
        : VERIFICATION_BLOCK_CONFIRMATIONS

    const raffle = await deploy("Raffle", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: waitBlockConfirmations
    })
}