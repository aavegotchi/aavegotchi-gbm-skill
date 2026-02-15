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

Install targets (kept in sync separately):
- Local (Clawd): `/Users/coderdan/Documents/GitHub/clawd-workspace/skills/aavegotchi-gbm-skill/`
- VPS (OpenClaw): `/home/agent/.openclaw/skills/aavegotchi-gbm-skill/`
