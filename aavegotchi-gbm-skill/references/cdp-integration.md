# Optional Integration: Coinbase CDP Server Wallet (No `PRIVATE_KEY` in `.env`)

This guide is an optional security upgrade for signing and broadcasting GBM transactions.

It does **not** replace the existing skill flow today:
- Existing `cast call` / `cast send --private-key` instructions remain valid.
- Use this guide when you want policy-gated server signing and stronger anti-phishing controls.

## Why Use CDP Here

Threat model improvements:
- No raw EOA private key in `.env`.
- Policy engine controls for chain, destination contract, and method selectors.
- Deterministic prepare -> execute workflow with TTL and explicit confirmation.

References:
- CDP Server Wallet v2 Quickstart: https://docs.cdp.coinbase.com/server-wallets/v2/quickstart
- CDP Policy Engine API: https://docs.cdp.coinbase.com/api-reference/v2/rest-api/policy-engine/create-a-policy
- OpenClaw tool approvals: https://docs.openclaw.ai/tools/exec-approvals

## Prerequisites

- Coinbase CDP project and Server Wallet credentials.
- Base mainnet target (`chainId=8453`).
- Existing GBM config from `SKILL.md` (`GBM_DIAMOND`, `GHST`, `USDC`, `GBM_SUBGRAPH_URL`).
- `cast` installed to derive selectors and validate calldata.

## Secure Credentials Pattern (Encrypted File Path)

```bash
export CDP_CREDENTIALS_PATH="$HOME/.openclaw/secrets/cdp-gbm.json.gpg"
export CDP_DECRYPT_CMD='gpg --quiet --decrypt'
```

Example decrypted JSON:

```json
{
  "apiKeyId": "cdp_api_key_id",
  "apiKeySecret": "cdp_api_key_secret",
  "walletSecret": "cdp_wallet_secret",
  "networkId": "base-mainnet",
  "accountAddress": "0xYourSignerAddress",
  "policyId": "optional_policy_id"
}
```

Store unencrypted source with `chmod 600` before encrypting.

## Wallet Bootstrap: Import vs Create

### Path A: Import existing EOA

Recommended when you need to preserve current balances and approvals.

1. Prepare one-time encrypted key material.
2. Import signer into CDP Server Wallet.
3. Verify imported signer equals existing `FROM_ADDRESS`.

### Path B: Create a new CDP wallet

1. Create new signer in CDP.
2. Fund it and reconfigure approvals as needed.
3. Update automation/operator docs with new address.

## Policy Setup Guidance (GBM)

Limit `evm.sendTransaction` to:
- Chain: Base mainnet only.
- Contract allowlist: `GBM_DIAMOND`, `GHST`, `USDC`, and approved NFT contracts.
- Selector allowlist: only required GBM operations.

Selector derivation commands:

```bash
cast sig "createAuction((uint80,uint80,uint56,uint8,bytes4,uint256,uint96,uint96),address,uint256)"
cast sig "cancelAuction(uint256)"
cast sig "commitBid(uint256,uint256,uint256,address,uint256,uint256,bytes)"
cast sig "swapAndCommitBid((address,uint256,uint256,uint256,address,uint256,uint256,uint256,address,uint256,uint256,bytes))"
cast sig "claim(uint256)"
cast sig "batchClaim(uint256[])"
cast sig "approve(address,uint256)"
cast sig "setApprovalForAll(address,bool)"
```

Recommended limits:
- Per-tx max value.
- Daily max notional.
- Optional deny window for out-of-hours automation.

## Prepare -> Execute Intent Pattern

Use a two-step broadcast model:

1. `prepare`: fetch latest auction data and build immutable tx intent.
2. `execute`: require explicit operator confirmation and unexpired TTL.

Required state checks before `execute`:
- Onchain `highestBid` still matches intended input.
- Auction not claimed/cancelled.
- Auction token params unchanged.

Suggested intent TTL: 300 seconds.

Example intent record:

```json
{
  "intentId": "sha256:...",
  "action": "commit_bid",
  "chainId": 8453,
  "to": "0x80320A0000C7A6a34086E2ACAD6915Ff57FfDA31",
  "data": "0x...",
  "value": "0x0",
  "createdAt": "2026-02-18T00:00:00.000Z",
  "expiresAt": "2026-02-18T00:05:00.000Z",
  "stateProof": {
    "auctionId": "...",
    "highestBid": "...",
    "tokenContract": "0x...",
    "tokenId": "...",
    "quantity": "..."
  },
  "status": "prepared"
}
```

## Prompt-Injection / Phishing Mitigation Checklist

- Reject any unsigned/unvalidated auction params from chat output.
- Validate addresses and uints before calldata encoding.
- Never execute raw user shell strings (`eval`, `bash -c`, `sh -c`).
- Require operator confirmation token for `execute` step.
- Expire intents quickly and require re-prepare on any state drift.

## OpenClaw Hardening Checklist

- Keep wallet execution tools disabled unless needed.
- Enable tool allowlist and command approvals for broadcast actions.
- Separate read-only tools (subgraph/onchain queries) from write tools.

References:
- https://docs.openclaw.ai/tools
- https://docs.openclaw.ai/sandboxing
- https://docs.openclaw.ai/tools/exec-approvals

## Troubleshooting

- Policy denies: confirm selector, destination, and chain match policy.
- Mismatch reverts: re-run prepare and refresh onchain auction state.
- Expired intents: regenerate intent with fresh auction snapshot.
- Signer mismatch: verify CDP signer address equals expected operator address.

## Fallback (Current Legacy Flow)

If CDP is unavailable, continue with the existing documented path in `SKILL.md`:
- Simulate with `cast call`.
- Broadcast with `cast send --private-key` only when explicitly instructed.

This change does **not** hard-migrate runtime behavior.
