{{ config(
	tags=['legacy'],
	materialized='view', alias = alias('contract_addresses', legacy_model=True)) }}

-- last updated 2023-03-21
with routers as (
    select * 
    from (values
         ('ethereum', '1inch', 'exchangeV1', 'Aggregator', '0xe4c577bdec9ce0f6c54f2f82aed5b1913b71ae2f'),
         ('ethereum', '1inch', 'exchangeV2', 'Aggregator', '0x0000000006adbd7c01bc0738cdbfc3932600ad63'),
         ('ethereum', '1inch', 'exchangeV3', 'Aggregator', '0x0000000053d411becdb4a82d8603edc6d8b8b3bc'),
         ('ethereum', '1inch', 'exchangeV4', 'Aggregator', '0x000005edbbc1f258302add96b5e20d3442e5dd89'),
         ('ethereum', '1inch', 'exchangeV5', 'Aggregator', '0x0000000f8ef4be2b7aed6724e893c1b674b9682d'),
         ('ethereum', '1inch', 'exchangeV6', 'Aggregator', '0x111112549cfedf7822eb11fbd8fd485d8a10f93f'),
         ('ethereum', '1inch', 'exchangeV7', 'Aggregator', '0x111111254b08ceeee8ad6ca827de9952d2a46781'),
         ('ethereum', '1inch', 'AggregationRouterV1', 'Aggregator', '0x11111254369792b2ca5d084ab5eea397ca8fa48b'),
         ('ethereum', '1inch', 'AggregationRouterV2', 'Aggregator', '0x111111125434b319222cdbf8c261674adb56f3ae'),
         ('ethereum', '1inch', 'AggregationRouterV3', 'Aggregator', '0x11111112542d85b3ef69ae05771c2dccff4faa26'),
         ('ethereum', '1inch', 'AggregationRouterV4', 'Aggregator', '0x1111111254fb6c44bac0bed2854e76f90643097d'),
         ('ethereum', '1inch', 'AggregationRouterV5', 'Aggregator', '0x1111111254eeb25477b68fb85ed929f73a960582'),
         ('ethereum', 'Uniswap', 'SwapRouter02', 'Router', '0x68b3465833fb72a70ecdf485e0e4c7bd8665fc45'),
         ('ethereum', 'Uniswap', 'SwapRouter', 'Router', '0xe592427a0aece92de3edee1f18e0157c05861564'),
         ('ethereum', 'Uniswap', 'Router02', 'Router', '0x7a250d5630b4cf539739df2c5dacb4c659f2488d'),
         ('ethereum', 'Uniswap', 'Router01', 'Router', '0xf164fc0ec4e93095b804a4795bbe1e041497b92a'),
         ('ethereum', 'Uniswap', 'UniversalRouter', 'Router', '0xef1c6e67703c7bd7107eed8303fbe6ec2554bf6b'),
         ('ethereum', 'Uniswap', 'UniswapX', 'Aggregator', '0xe80bf394d190851e215d5f67b67f8f5a52783f1e'),
         ('ethereum', 'ZeroEx', 'ZeroExProxy', 'Aggregator', '0xe66b31678d6c16e9ebf358268a790b763c133750'),
         ('ethereum', 'ZeroEx', 'ExchangeProxy', 'Aggregator', '0xdef1c0ded9bec7f1a1670819833240f027b25eff'),
         ('ethereum', 'MetaMask', 'MetaMask', 'Aggregator of Aggregators', '0x881d40237659c251811cec9c364ef91dc08d300c'),
         ('ethereum', 'GemSwap', 'GemSwap', 'Router', '0x83c8f28c26bf6aaca652df1dbbe0e1b56f8baba2'),
         ('ethereum', 'SushiSwap', 'Router02', 'Router', '0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f'),
         ('ethereum', 'ParaSwap', 'AugustusSwapper6.0', 'Aggregator', '0xdef171fe48cf0115b1d80b88dc8eab59176fee57'),
         ('ethereum', 'ShibaSwap', 'UniswapV2Router02', 'Router', '0x03f7724180aa6b939894b5ca4314783b0b36b329'),
         ('ethereum', 'Odos', '', 'Aggregator', '0x76f4eed9fe41262669d0250b2a97db79712ad855'),
         ('ethereum', 'CoW Swap', 'GPv2Settlement', 'Aggregator of Aggregators', '0x9008d19f58aabd9ed0d60971565aa8510560ab41'),
         ('ethereum', 'THORSwap', '', '#N/A', '0xc145990e84155416144c532e31f89b840ca8c2ce'),
         --('ethereum', 'Balancer', 'Vault', 'Router', '0xba12222222228d8ba445958a75a0704d566bf2c8'),
         ('ethereum', 'Curvefi', 'threepool_swap', 'Router', '0xbebc44782c7db0a1a60cb6fe97d0b483032ff1c7'),
         ('ethereum', 'Curvefi', 'steth_swap', 'Router', '0xdc24316b9ae028f1497c275eb9192a3ea0f67022'),
         ('ethereum', 'Socket', '', 'Aggregator of Aggregators', '0xc30141b657f4216252dc59af2e7cdb9d8792e1b0'),
         ('ethereum', 'DODO', 'DODORouteProxy', 'Aggregator', '0xa2398842f37465f89540430bdc00219fa9e4d28a'),
         ('ethereum', 'Rainbow', 'RainbowRouter', 'Aggregator of Aggregators', '0x00000000009726632680fb29d3f7a9734e3010e2'),
         ('ethereum', 'Tokenlon', 'Tokenlon', 'Aggregator', '0x03f34be1bf910116595db1b11e9d1b2ca5d59659'),
         ('ethereum', 'Kyber', 'MetaAggregationRouter', 'Aggregator', '0x617dee16b86534a5d792a4d7a62fb491b544111e'),
         ('ethereum', 'Swapr', 'Swapr', 'Router', '0xb9960d9bca016e9748be75dd52f02188b9d0829f'),
         ('ethereum', 'Dfx_finance', 'Router', 'Router', '0x9d0950c595786aba7c26dfddf270d66a8b18b4fa'),
         ('ethereum', 'OKX DEX', '', 'Router', '0x3b3ae790df4f312e745d270119c6052904fb6790'),
         ('ethereum', 'Stargate', 'Router', 'Router', '0x8731d54e9d02c286767d56ac03e8037c07e01e98'),
         ('ethereum', 'Openocean', 'OpenOceanExchangeProxy', 'Aggregator', '0x6352a56caadc4f1e25cd6c75970fa768a3304e64'),
         ('bnb', 'Slingshot Finance', 'Swap', 'Aggregator', '0x224b239b8bb896f125bd77eb334e302a318d9e33'),
         ('bnb', 'ZeroEx', 'Exchange', 'Aggregator', '0x3f93c3d9304a70c9104642ab8cd37b1e2a7c203a'),
         ('bnb', 'ZeroEx', 'ExchangeProxy', 'Aggregator', '0xdef1c0ded9bec7f1a1670819833240f027b25eff'),
         ('bnb', 'ParaSwap', '', 'Aggregator', '0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57'),
         ('bnb', 'PancakeSwap', 'pancakeswap_v2', 'Router', '0x10ed43c718714eb63d5aa57b78b54704e256024e'),
         ('bnb', 'PancakeSwap', 'PancakeRouter', 'Router', '0x05ff2b0db69458a0750badebc4f9e13add608c7f'),
         ('bnb', 'PancakeSwap', 'PancakeZapV1', 'Router', '0xd4c4a7c55c9f7b3c48bafb6e8643ba79f42418df'),
         ('bnb', 'PancakeSwap', 'PancakeSwapSmartRouter', 'Router', '0x2f22e47ca7c5e07f77785f616ceee80c5e84127c'),
         ('bnb', 'SushiSwap', 'SushiXSwap', 'Router', '0x7a4af156379f512de147ed3b96393047226d923f'),
         ('bnb', 'MetaMask', '', 'Aggregator of Aggregators', '0x1a1ec25dc08e98e5e93f1104b5e5cdd298707d31'),
         ('bnb', 'FstSwap', '', 'Router', '0xb3ca4d73b1e0ea2c53b42173388cc01e1c226f40'),
         ('bnb', '1inch', 'AggregationRouterV3', 'Aggregator', '0x11111112542d85b3ef69ae05771c2dccff4faa26'),
         ('bnb', '1inch', 'AggregationRouterV5', 'Aggregator', '0x1111111254eeb25477b68fb85ed929f73a960582'),
         ('bnb', '1inch', 'AggregationRouterV4', 'Aggregator', '0x1111111254fb6c44bac0bed2854e76f90643097d'),
         ('bnb', 'BiSwap', '', 'Router', '0x3a6d8ca21d1cf76f653a67577fa0d27453350dd8'),
         ('bnb', 'TransitSwap', 'XswapProxyV3', '#N/A', '0x638f32fe09baec1fdc54f962e3e8e5f2b286aa70'),
         ('bnb', 'ApeSwap', '', 'Router', '0xcf0febd3f17cef5b47b0cd257acf6025c5bff3b7'),
         ('bnb', 'Bogged Finance', '', 'Aggregator', '0xb099ed146fad4d0daa31e3810591fc0554af62bb'),
         ('bnb', 'NomiSwap', '', 'Router', '0xd654953d746f0b114d1f85332dc43446ac79413d'),
         ('bnb', 'SafeMoon', '', 'Router', '0x37da632c6436137bd4d0ca30c98d3c615974120b'),
         ('bnb', 'Cone', 'ConeRouter01', 'Router', '0xbf1fc29668e5f5eaa819948599c9ac1b1e03e75f'),
         ('bnb', 'BabySwap', '', 'Router', '0x8317c460c22a9958c27b4b6403b98d2ef4e2ad32'),
         ('bnb', 'DODO', 'DODORouteProxy', 'Router', '0x6b3d817814eabc984d51896b1015c0b89e9737ca'),
         ('bnb', 'Mdex', 'MdexRouter', 'Router', '0x62c1a0d92b09d0912f7bb9c96c5ecdc7f2b87059'),
         ('bnb', 'Mdex', 'MdexRouter', 'Router', '0x7dae51bd3e3376b8c7c4900e9107f12be3af1ba8'),
         ('bnb', 'Wombat', 'WombatRouter', 'Router', '0x19609b03c976cca288fbdae5c21d4290e9a4add7'),
         ('bnb', 'WooFi', 'WooRouterV2', 'Router', '0xcef5be73ae943b77f9bc08859367d923c030a269'),
         ('bnb', 'BitKeep', '', 'Aggregator', '0x6f5ac65ca70f2a44d73c8f711cb2bdf425d9f304'),
         ('bnb', 'TransitSwap', 'TransitSwapRouterV4', 'Aggregator', '0xb45a2dda996c32e93b8c47098e90ed0e7ab18e39'),
         ('bnb', 'Openocean', 'openocean_v2', 'Aggregator', '0x6352a56caadc4f1e25cd6c75970fa768a3304e64'),
         ('polygon', '1inch', 'AggregationRouterV3', 'Aggregator', '0x11111112542d85b3ef69ae05771c2dccff4faa26'),
         ('polygon', '1inch', 'AggregationRouterV4', 'Aggregator', '0x1111111254fb6c44bac0bed2854e76f90643097d'),
         ('polygon', '1inch', 'AggregationRouterV5', 'Aggregator', '0x1111111254eeb25477b68fb85ed929f73a960582'),
         ('polygon', 'MetaMask', '', 'Aggregator of Aggregators', '0x1a1ec25dc08e98e5e93f1104b5e5cdd298707d31'),
         ('polygon', 'QuickSwap', 'UniswapV2Router02', 'Router', '0xa5e0829caced8ffdd4de3c43696c57f7d7a678ff'),
         ('polygon', 'QuickSwap', 'UniswapV2Pair', 'Router', '0x2cf7252e74036d1da831d11089d326296e64a728'),
         ('polygon', 'Uniswap', 'SwapRouter02', 'Router', '0x68b3465833fb72a70ecdf485e0e4c7bd8665fc45'),
         ('polygon', 'ParaSwap', 'AugustusSwapperV4', '#N/A', '0x90249ed4d69d70e709ffcd8bee2c5a566f65dade'),
         ('polygon', 'ParaSwap', 'AugustusSwapperV5', 'Aggregator', '0xdef171fe48cf0115b1d80b88dc8eab59176fee57'),
         ('polygon', 'Slingshot Finance', 'slingshot_trading_contract', 'Aggregator', '0xf2e4209afa4c3c9eaa3fb8e12eed25d8f328171c'),
         ('polygon', 'Kyber', 'AggregationRouterV2', 'Aggregator', '0xdf1a1b60f2d438842916c0adc43748768353ec25'),
         ('polygon', 'Kyber', 'Kyber Swap: Router', 'Aggregator', '0x546c79662e028b661dfb4767664d0273184e4dd1'),
         ('polygon', 'ZeroEx', 'ExchangeProxy', 'Aggregator', '0xdef1c0ded9bec7f1a1670819833240f027b25eff'),
         ('polygon', 'TransitSwap', '', 'Aggregator', '0x8b48715c5d6d1645663a4c460ea85ce846b8580e'),
         ('polygon', 'Odos', '', 'Aggregator', '0xa32ee1c40594249eb3183c10792bcf573d4da47c'),
         ('polygon', 'BitKeep', '', '#N/A', '0xf6463845b0b9d9d33d8e2bcb6c628bc5cb1ad133'),
         ('polygon', 'Fraxswap', 'FraxswapRouter', 'Router', '0x9bc2152fd37b196c0ff3c16f5533767c9a983971'),
         ('polygon', 'Socket', 'Registry', 'Aggregator of Aggregators', '0xc30141b657f4216252dc59af2e7cdb9d8792e1b0'),
         ('polygon', 'SushiSwap', 'UniswapV2Router02', 'Router', '0x1b02da8cb0d097eb8d57a175b88c7d8b47997506'),
         ('polygon', 'Via router', 'ViaRouter', 'Aggregator of Aggregators', '0x777777773fdd8b28bb03377d10fcea75ad9768da'),
         ('polygon', 'Kyber', 'MetaAggregationRouter', 'Aggregator', '0x617dee16b86534a5d792a4d7a62fb491b544111e'),
         ('polygon', 'Slingshot Finance', '', 'Aggregator', '0x07e56b727e0eacfa53823977599905024c2de4f0'),
         ('polygon', 'DODO', 'DODOV2Proxy02', 'Aggregator', '0xa222e6a71d1a1dd5f279805fbe38d5329c1d0e70'),
         ('polygon', 'DODO', 'DODORouteProxy', 'Aggregator', '0x2fa4334cfd7c56a0e7ca02bd81455205fcbdc5e9'),
         ('polygon', 'LiFi', 'LiFiDiamond_v2', 'Aggregator of Aggregators', '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'),
         ('polygon', 'Bitkeep', '', 'Aggregator', '0xf5bfcbda96de6a55a3a80af5175a1cbb088d5338'),
         ('optimism', 'Slingshot Finance', 'Swap', '#N/A', '0x00c0184c0b5d42fba6b7ca914b31239b419ab80b'),
         ('optimism', 'SushiSwap', 'SushiXSwap', 'Router', '0x8b396ddf906d552b2f98a8e7d743dd58cd0d920f'),
         ('optimism', 'Uniswap', 'SwapRouter', 'Router', '0xe592427a0aece92de3edee1f18e0157c05861564'),
         ('optimism', 'Uniswap', 'SwapRouter02', 'Router', '0x68b3465833fb72a70ecdf485e0e4c7bd8665fc45'),
         ('optimism', '1inch', 'AggregationRouterV4', 'Aggregator', '0x1111111254760f7ab3f16433eea9304126dcd199'),
         ('optimism', '1inch', 'AggregationRouterV3', 'Aggregator', '0x11111112542d85b3ef69ae05771c2dccff4faa26'),
         ('optimism', '1inch', 'AggregationRouterV5', 'Aggregator', '0x1111111254eeb25477b68fb85ed929f73a960582'),
         ('optimism', 'ZeroEx', 'ExchangeProxy', 'Aggregator', '0xdef1abe32c034e558cdd535791643c58a13acc10'),
         ('optimism', 'Clipper', 'ClipperPackedVerifiedExchange', 'Router', '0x5130f6ce257b8f9bf7fac0a0b519bd588120ed40'),
         ('optimism', 'Stargate', 'Router', 'Router', '0xb0d502e938ed5f4df2e681fe6e419ff29631d62b'),
         ('optimism', 'Velodrome', 'Router', 'Router', '0xa132dab612db5cb9fc9ac426a0cc215a3423f9c9'),
         ('optimism', 'Velodrome', 'Router', 'Router', '0x9c12939390052919af3155f41bf4160fd3666a6f'),
         ('optimism', 'Socket', 'Registry', 'Aggregator of Aggregators', '0xc30141b657f4216252dc59af2e7cdb9d8792e1b0'),
         ('optimism', 'Odos', 'OdosRouter', 'Aggregator', '0x69dd38645f7457be13571a847ffd905f9acbaf6d'),
         ('optimism', 'WooFi', 'WooRouter', 'Router', '0xeaf1ac8e89ea0ae13e0f03634a4ff23502527024'),
         ('optimism', 'LiFi', 'LiFiDiamond_v2', 'Aggregator of Aggregators', '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'),
         ('optimism', 'Via router', 'ViaRouter', 'Aggregator of Aggregators', '0x777777773fdd8b28bb03377d10fcea75ad9768da'),
         ('arbitrum', 'Uniswap', 'SwapRouter02', 'Router', '0x68b3465833fb72a70ecdf485e0e4c7bd8665fc45'),
         ('arbitrum', 'SushiSwap', 'UniswapV2Router02', 'Router', '0x1b02da8cb0d097eb8d57a175b88c7d8b47997506'),
         ('arbitrum', 'Slingshot Finance', 'Swap', '#N/A', '0xe8c97bf6d084880de38aec1a56d97ed9fdfa0c9b'),
         ('arbitrum', 'GMX', 'Router', 'Router', '0xabbc5f99639c9b6bcb58544ddf04efa6802f4064'),
         ('arbitrum', 'GMX', 'OrderBookReader', '#N/A', '0xa27c20a7cf0e1c68c0460706bb674f98f362bc21'),
         ('arbitrum', 'GMX', 'PositionRouter', '#N/A', '0x3d6ba331e3d9702c5e8a8d254e5d8a285f223aba'),
         ('arbitrum', '1inch', 'AggregationRouterV3', 'Aggregator', '0x11111112542d85b3ef69ae05771c2dccff4faa26'),
         ('arbitrum', '1inch', 'AggregationRouterV4', 'Aggregator', '0x1111111254fb6c44bac0bed2854e76f90643097d'),
         ('arbitrum', 'Stargate', 'Router', 'Router', '0x53bf833a5d6c4dda888f69c22c88c9f356a41614'),
       --  ('arbitrum', 'Balancer', 'Vault', 'Router', '0xba12222222228d8ba445958a75a0704d566bf2c8'),
         ('arbitrum', 'Odos', 'OdosRouter', 'Aggregator', '0xdd94018f54e565dbfc939f7c44a16e163faab331'),
         ('arbitrum', '1inch', 'AggregationRouterV5', 'Aggregator', '0x1111111254eeb25477b68fb85ed929f73a960582'),
         ('arbitrum', 'Socket', 'Registry', 'Aggregator of Aggregators', '0xc30141b657f4216252dc59af2e7cdb9d8792e1b0'),
         ('arbitrum', 'DODO', 'DODORouteProxy', 'Aggregator', '0x3b6067d4caa8a14c63fdbe6318f27a0bbc9f9237'),
         ('arbitrum', 'ZeroEx', 'ExchangeProxy', 'Aggregator', '0xdef1c0ded9bec7f1a1670819833240f027b25eff'),
         ('arbitrum', 'Slingshot Finance', '', 'Aggregator', '0x5543550d65813c1fa76242227cbba0a28a297771'),
         ('arbitrum', 'Via router', 'ViaRouter', 'Aggregator of Aggregators', '0x777777773fdd8b28bb03377d10fcea75ad9768da'),
         ('arbitrum', 'LiFi', 'LiFiDiamond_v2', 'Aggregator of Aggregators', '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'),
         ('avalanche_c', 'Trader Joe', 'JoeRouter02', 'Router', '0x60ae616a2155ee3d9a68541ba4544862310933d4'),
         ('avalanche_c', 'Trader Joe', 'SwapLogic', 'Router', '0x079c68167f85cb06ed550149cce250e06dc3c52d'),
         ('avalanche_c', 'Trader Joe', 'JoePair', 'Router', '0xed8cbd9f0ce3c6986b22002f03c6475ceb7a6256'),
         ('avalanche_c', '1inch', 'AggregationRouterV5', 'Aggregator', '0x1111111254eeb25477b68fb85ed929f73a960582'),
         ('avalanche_c', '1inch', 'AggregationRouterV4', 'Aggregator', '0x1111111254fb6c44bac0bed2854e76f90643097d'),
         ('avalanche_c', 'MetaMask', '', 'Aggregator of Aggregators', '0x1a1ec25dc08e98e5e93f1104b5e5cdd298707d31'),
         ('avalanche_c', 'SushiSwap', 'SushiSwapRouter', 'Router', '0x1b02da8cb0d097eb8d57a175b88c7d8b47997506'),
         ('avalanche_c', 'SushiSwap', 'SushiXSwap', 'Router', '0x2c8c987c4777ab740d20cb581f5d381be95a4a4a'),
         ('avalanche_c', 'Bogged Finance', '', 'Aggregator', '0xb099ed146fad4d0daa31e3810591fc0554af62bb'),
         ('avalanche_c', 'AnySwap', '', 'Router', '0xb0731d50c681c45856bfc3f7539d5f61d4be81d8'),
         ('avalanche_c', 'Pangolin Exchange', 'PangolinRouter', 'Router', '0xe54ca86531e17ef3616d22ca28b0d458b6c89106'),
         ('avalanche_c', 'Socket', 'Registry', 'Aggregator of Aggregators', '0x2b42affd4b7c14d9b7c2579229495c052672ccd3'),
         ('avalanche_c', 'Odos', '', 'Aggregator', '0xfe7ce93ac0f78826cd81d506b07fe9f459c00214'),
         ('avalanche_c', 'GMX', 'Router', 'Router', '0x5f719c2f1095f7b9fc68a68e35b51194f4b6abe8'),
         ('avalanche_c', 'WooFi', 'WooCrossChainRouter', 'Router', '0xdf37f7a85d4563f39a78494568824b4df8669b7a'),
         ('avalanche_c', 'WooFi', 'WooRouterV2', 'Router', '0x5aa6a4e96a9129562e2fc06660d07feddaaf7854'),
         ('gnosis', '1inch', 'AggregationRouterV4', 'Aggregator', '0x1111111254fb6c44bac0bed2854e76f90643097d'),
         ('gnosis', '1inch', 'AggregationRouterV5', 'Aggregator', '0x1111111254eeb25477b68fb85ed929f73a960582'),
         ('gnosis', 'HoneySwap', 'UniswapV2Router02', 'Router', '0x1c232f01118cb8b424793ae03f870aa7d0ac7f77'),
         ('gnosis', 'SushiSwap', '', 'Router', '0x1b02da8cb0d097eb8d57a175b88c7d8b47997506'),
         ('gnosis', 'CoW Swap', 'CoW Protocol: Settlement', 'Aggregator of Aggregators', '0x9008d19f58aabd9ed0d60971565aa8510560ab41'),
         ('gnosis', 'Levinswap', 'UniswapV2Router02', 'Router', '0xb18d4f69627f8320619a696202ad2c430cef7c53'),
         ('gnosis', 'Swapr', 'DXswapRouter', 'Router', '0xe43e60736b1cb4a75ad25240e2f9a62bff65c0c0'),
         ('gnosis', 'Baoswap', 'UniswapV2Router02', 'Router', '0x6093aebac87d62b1a5a4ceec91204e35020e38be'),
         ('gnosis', 'Socket', 'Registry', 'Aggregator of Aggregators', '0xc30141b657f4216252dc59af2e7cdb9d8792e1b0'),
         ('gnosis', 'LiFi', 'LiFiDiamond_v2', 'Aggregator', '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'),
         ('fantom', '1inch', 'AggregationRouterV4', 'Aggregator', '0x1111111254fb6c44bac0bed2854e76f90643097d'),
         ('fantom', '1inch', 'AggregationRouterV5', 'Aggregator', '0x1111111254eeb25477b68fb85ed929f73a960582'),
         ('fantom', 'ZeroEx', '0x: Exchange Proxy', 'Aggregator', '0xdef189deaef76e379df891899eb5a00a94cbc250'),
         ('fantom', 'Paraswap', 'Paraswap', 'Aggregator', '0xdef171fe48cf0115b1d80b88dc8eab59176fee57'),
         ('fantom', 'Kyber', 'KyberSwap: Meta Aggregation Router', 'Aggregator', '0x617dee16b86534a5d792a4d7a62fb491b544111e'),
         ('fantom', 'Kyber', 'Kyber Swap: Aggregation Router 2', 'Aggregator', '0xdf1a1b60f2d438842916c0adc43748768353ec25'),
         ('fantom', 'Kyber', 'Kyber Swap: Aggregation Router 3', 'Aggregator', '0x00555513acf282b42882420e5e5ba87b44d8fa6e'),
         ('fantom', 'Kyber', 'Kyber: Aggregation Router', 'Aggregator', '0x1fc3607fa67b58deddb0faf7a116f417a20c551c'),
         ('fantom', 'Firebird', 'Firebird', 'Aggregator', '0xe0c38b2a8d09aad53f1c67734b9a95e43d5981c0'),
         ('fantom', 'OpenOcean', 'OpenOceanExchange.V2', 'Aggregator', '0x6352a56caadc4f1e25cd6c75970fa768a3304e64'),
         ('fantom', 'BogSwap', 'BogSwap', 'Aggregator', '0xb099ed146fad4d0daa31e3810591fc0554af62bb')
    )
    as t (blockchain
        , project
        , contract_name
        , contract_type
        , contract_address)
) 

select 
  blockchain
  , project
  , contract_name
  , contract_type
  , lower(contract_address) as contract_address
from routers