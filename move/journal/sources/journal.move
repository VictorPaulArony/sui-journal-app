/*
/// Module: journal
module journal::journal;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module journal::journal;

use std::ascii::String;
use sui::clock::Clock;
use sui::clock::timestamp_ms;

const ENOTOWNER: u64 = 1;

public struct Entries has store, copy, drop {
    content: String,
    create_at_ms: u64
}

//journal object for entries
public struct Journal has key, store {
    id: UID,
    title: String,
    owner: address,
    entries: vector<Entries>,
}

//function to create a new journal for the user
public fun new_journal(
    title:String,
    ctx: &mut TxContext

    ): Journal {
        let new_journal = Journal {
            id: object::new(ctx),
            title,
            owner: tx_context::sender(ctx),
            entries: vector::empty(),
        };
        new_journal
    }

    //function to add a new entry to the journal
    public fun add_entry(
        journal: &mut Journal,
        content: String,
        clock: &Clock,
        ctx: &mut TxContext
    ){
        assert!(journal.owner == tx_context::sender(ctx), ENOTOWNER);
        let entry = Entries {
            content,
            create_at_ms: timestamp_ms(clock)
        };
        vector::push_back(&mut journal.entries, entry);
    }

    //function to get total number of entries in the journal
    public fun get_entry_count(journal: &Journal): u64 {
        vector::length(&journal.entries)
    }

    //function to get journal owner
    public fun get_journal_owner(journal: &Journal): address {
        journal.owner
    }