#[starknet::interface]
trait IAuraEscrow<TContractState> {
    fn deposit_liquidity(ref self: TContractState, amount: u256);
    fn lock_intent(ref self: TContractState, btc_amount: u256, l2_amount: u256, btc_recipient: u256);
    fn confirm_swap(ref self: TContractState, intent_id: u64, btc_tx_id: u256, proof: Array<felt252>);
    fn get_intent(self: @TContractState, intent_id: u64) -> (u256, u256, u256, u8);
    fn get_liquidity(self: @TContractState) -> u256;
}

#[starknet::contract]
mod AuraEscrow {
    use starknet::{ContractAddress, get_caller_address};
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess, Map};

    // Intent Status: 0=NONE, 1=LOCKED, 2=COMPLETED, 3=CANCELLED
    const STATUS_LOCKED: u8 = 1;
    const STATUS_COMPLETED: u8 = 2;

    #[storage]
    struct Storage {
        liquidity: u256,
        intents_count: u64,
        // intent_id -> (btc_amount, l2_amount, btc_recipient, status)
        intents_btc_amount: Map<u64, u256>,
        intents_l2_amount: Map<u64, u256>,
        intents_recipient: Map<u64, u256>,
        intents_status: Map<u64, u8>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        LiquidityDeposited: LiquidityDeposited,
        IntentCreated: IntentCreated,
        SwapConfirmed: SwapConfirmed,
    }

    #[derive(Drop, starknet::Event)]
    struct LiquidityDeposited {
        provider: ContractAddress,
        amount: u256
    }

    #[derive(Drop, starknet::Event)]
    struct IntentCreated {
        intent_id: u64,
        user: ContractAddress,
        btc_amount: u256,
        l2_amount: u256
    }

    #[derive(Drop, starknet::Event)]
    struct SwapConfirmed {
        intent_id: u64,
        btc_tx_id: u256
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.intents_count.write(0);
        self.liquidity.write(1000000000000000000); // Initial 1.0 ETH worth of liq for demo
    }

    #[abi(embed_v0)]
    impl AuraEscrowImpl of super::IAuraEscrow<ContractState> {
        fn deposit_liquidity(ref self: ContractState, amount: u256) {
            let current = self.liquidity.read();
            self.liquidity.write(current + amount);
            
            self.emit(LiquidityDeposited {
                provider: get_caller_address(),
                amount: amount
            });
        }

        fn lock_intent(ref self: ContractState, btc_amount: u256, l2_amount: u256, btc_recipient: u256) {
            let count = self.intents_count.read();
            
            self.intents_btc_amount.write(count, btc_amount);
            self.intents_l2_amount.write(count, l2_amount);
            self.intents_recipient.write(count, btc_recipient);
            self.intents_status.write(count, STATUS_LOCKED);
            
            self.intents_count.write(count + 1);

            self.emit(IntentCreated {
                intent_id: count,
                user: get_caller_address(),
                btc_amount: btc_amount,
                l2_amount: l2_amount
            });
        }

        fn confirm_swap(ref self: ContractState, intent_id: u64, btc_tx_id: u256, proof: Array<felt252>) {
            let status = self.intents_status.read(intent_id);
            assert(status == STATUS_LOCKED, 'Intent status invalid');
            
            let l2_amount = self.intents_l2_amount.read(intent_id);
            
            // In a production version, we would verify the 'proof' against a 
            // STARK-proof verifier contract that checks the Bitcoin block inclusion.
            // For the Re{define} demo, we assume the proof is validated if provided.
            assert(proof.len() > 0, 'Invalid ZK proof');
            
            self.intents_status.write(intent_id, STATUS_COMPLETED);
            
            // Logic to transfer l2_tokens (e.g. STRK) to the user
            let current_liq = self.liquidity.read();
            assert(current_liq >= l2_amount, 'Insufficient liquidity');
            self.liquidity.write(current_liq - l2_amount);

            self.emit(SwapConfirmed {
                intent_id: intent_id,
                btc_tx_id: btc_tx_id
            });
        }

        fn get_intent(self: @ContractState, intent_id: u64) -> (u256, u256, u256, u8) {
            (
                self.intents_btc_amount.read(intent_id),
                self.intents_l2_amount.read(intent_id),
                self.intents_recipient.read(intent_id),
                self.intents_status.read(intent_id)
            )
        }

        fn get_liquidity(self: @ContractState) -> u256 {
            self.liquidity.read()
        }
    }
}
