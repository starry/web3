#[test_only]
module web3::chat_tests {
    use web3::chat::{Self, Chat};
    use std::ascii::Self;
    use sui::test_scenario::Self;
    use std::debug;

    const USER_ADDRESS: address = @0xA001;
    const METADATA: vector<u8> = vector[0u8];
    const HELLO: vector<u8> = vector[72, 101, 108, 108, 111]; // "Hello" in ASCII.

    #[test]
    fun test_chat() {
        let scenario_val = test_scenario::begin(USER_ADDRESS);
        let scenario = &mut scenario_val;

        {
            chat::post(@0xC001, HELLO, METADATA, test_scenario::ctx(scenario));
        };

        test_scenario::next_tx(scenario, USER_ADDRESS);
        {
            assert!(test_scenario::has_most_recent_for_sender<Chat>(scenario), 0);
            let chat = test_scenario::take_from_sender<Chat>(scenario);
            assert!(chat::text(&chat) == ascii::string(HELLO), 0);
            debug::print(&chat);
            test_scenario::return_to_sender(scenario, chat);
        };
        test_scenario::end(scenario_val);
    }
}