# lock tokens on L1
cast send 0xa2969e30ff87ffd5fd5529a54c8ce95c0b86e51b \
    "lockFunds(address,uint256)" \
    <TOKEN_ADDRESS> 1000 \
    --rpc-url $SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY

# map tokens on L2
cast send 0xa80bf52c09e35e9a3c4fc210b72f32ebc9fc61cb182dc7e3402a3674390e27fa \
    "mapToken(address,address)" \
    <L1_TOKEN_ADDRESS> <L2_TOKEN_ADDRESS> \
    --rpc-url $SCROLL_DEVNET \
    --private-key $PRIVATE_KEY

# check locked funds on L2
cast call 0xa80bf52c09e35e9a3c4fc210b72f32ebc9fc61cb182dc7e3402a3674390e27fa \
    "getLockedFundsFromL1(address,address)" \
    <L1_TOKEN_ADDRESS> <USER_ADDRESS> \
    --rpc-url $SCROLL_DEVNET

# mint tokens on L2
cast send 0xa80bf52c09e35e9a3c4fc210b72f32ebc9fc61cb182dc7e3402a3674390e27fa \
    "mint(address,address)" \
    <L1_TOKEN_ADDRESS> <USER_ADDRESS> \
    --rpc-url $SCROLL_RPC_URL \
    --private-key $PRIVATE_KEY
