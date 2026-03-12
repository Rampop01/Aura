# AURA: Private Bitcoin Gateway for Starknet

![AURA Banner](https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format&fit=crop&q=80&w=2832&ixlib=rb-4.0.3)

**AURA** is a trustless, privacy-preserving OTC desk that bridges Bitcoin L1 liquidity directly into the Starknet L2 ecosystem. Built for the **Re{define} Hackathon 2026**, AURA solves the "Privacy & Bitcoin" narrative by combining ZK-STARKs with trust-minimized atomic swaps.

## 🔒 The Challenge
Institutional adoption of Bitcoin DeFi in 2026 requires two things: **Liquidity** and **Compliance-ready Privacy**. Current solutions rely on centralized bridges or public-only swaps that leak trade metadata, leading to MEV and regulatory friction.

## 🚀 Our Solution: AURA
AURA allows users to swap native BTC for Starknet assets (USDC, STRK, ETH) without:
1.  **Trusting a central bridge**: Uses atomic locks and ZK-verification.
2.  **Leaking Transaction History**: Employs ZK-STARKs on Starknet to obscure the recipient's identity and swap amount.
3.  **High Latency**: Leverages Starknet's fast finality for the L2 leg of the swap.

### Key Features
- **ZK-Shielded Swaps**: Proves the validity of a BTC transaction to a Starknet contract without revealing the full Bitcoin transaction graph.
- **OP_CAT Ready**: Architecture designed to leverage future Bitcoin Covenants for fully trustless script-based releases.
- **Glassmorphism UI**: A premium, "institutional-grade" dashboard designed for visual excellence.

## 🛠 Tech Stack
- **Frontend**: Next.js 14 (App Router), Tailwind CSS, Framer Motion.
- **Starknet**: Cairo 2.x smart contracts.
- **Bitcoin**: Xverse API for L1 transaction handling, Mempool.space for block verification.
- **ZK-Proof**: Starknet's native STARK proof system.

## 📁 Repository Structure
```text
aura/
├── frontend/        # Next.js Application (Visual Dashboard)
├── smartcontract/   # Cairo Contracts (Escrow & Verification Logic)
└── relay/           # (Optional) Proof Relayer (Mocked for Demo)
```

## 🎯 Track Focus
- **Privacy Track**: High focus on ZK-Shielding for trade metadata.
- **Bitcoin Track**: Direct integration with L1 Bitcoin and Xverse wallet.

---

### Developed By
[Your Name/Team Name]
*Re{define} Hackathon 2026 Submission*
