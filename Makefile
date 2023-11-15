build:
	forge build

equiv:
	#act hevm --spec spec/tokens/erc20.act --sol src/tokens/erc20.sol --contract ERC20
	act hevm --spec spec/utils/auth.act --sol src/utils/auth.sol --contract Auth

