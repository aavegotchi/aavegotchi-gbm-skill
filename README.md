# aavegotchi-gbm-skill

This repo contains the `aavegotchi-gbm-skill` skill folder (docs-first) for interacting with Aavegotchi GBM auctions on Base mainnet:
- View/list auctions via the Goldsky GBM subgraph
- Create auctions (ERC721 + ERC1155)
- Bid (GHST direct) or bid via swap (`swapAndCommitBid`) with USDC/ETH
- Cancel and claim auctions
- Safety-first `DRY_RUN` default (simulate with `~/.foundry/bin/cast call`, only broadcast with `~/.foundry/bin/cast send` when explicitly set)

Skill contents:
- `aavegotchi-gbm-skill/SKILL.md`
- `aavegotchi-gbm-skill/references/`

## Optional Secure Alternative: Coinbase CDP Server Wallet

Current private-key-based broadcast instructions remain supported.

If you want to integrate policy-controlled server signing and avoid raw private keys in `.env`, see:
- `aavegotchi-gbm-skill/references/cdp-integration.md`

This repo change is docs-only and does not perform a hard migration.
