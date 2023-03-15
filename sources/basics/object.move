module web3::object {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct Object has key {
        id: UID,
        custom_field: u64,
        child_obj: ChildObject,
        nested_obj: AnotherObject,
    }

    struct ChildObject has store {
        a_field: bool,
    }

    struct AnotherObject has key, store {
        id: UID,
    }

    public fun write_field(o: &mut Object, v: u64) {
        if (some_conditional_logic()) {
            o.custom_field = v
        }
    }

    public fun transfer(o: Object, recipient: address) {
        assert!(some_conditional_logic(), 0);
        transfer::transfer(o, recipient)
    }

    public fun read_field(o: &Object): u64 {
        o.custom_field
    }

    public fun create(tx: &mut TxContext): Object {
        Object {
            id: object::new(tx),
            custom_field: 0,
            child_obj: ChildObject { a_field: false },
            nested_obj: AnotherObject { id: object::new(tx) }
        }
    }

    public entry fun main(
        to_read: &Object,      // The argument of type Object is passed as a read-only reference
        to_write: &mut Object, // The argument is passed as a mutable reference
        to_consume: Object,    // The argument is passed as a value
        // ... end objects, begin primitive type inputs
        int_input: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let v = read_field(to_read);
        write_field(to_write, v + int_input);
        transfer(to_consume, recipient);
        // demonstrate creating a new object for the sender
        let sender = tx_context::sender(ctx);
        transfer::transfer(create(ctx), sender)
    }

    fun some_conditional_logic(): bool {
        // placeholder for checks implemented in arbitrary Move code
        true
    }
}