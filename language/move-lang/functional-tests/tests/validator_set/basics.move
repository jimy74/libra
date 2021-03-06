//! account: bob, 1000000, 0, validator
//! account: vivian, 1000000, 0, validator
//! account: alice

//! new-transaction
script {
use 0x1::LibraSystem;
fun main(account: &signer) {
    LibraSystem::initialize_validator_set(account);
}
}
// TODO(status_migration) remove duplicate check
// check: ABORTED
// check: ABORTED
// check: 0

//! new-transaction
script {
    use 0x1::LibraSystem;
    fun main(account: &signer) {
        LibraSystem::update_config_and_reconfigure(account, {{bob}});
    }
}
// TODO(status_migration) remove duplicate check
// check: ABORTED
// check: ABORTED
// check: 1

//! new-transaction
//! sender: bob
script {
    use 0x1::ValidatorConfig;
    fun main(account: &signer) {
        ValidatorConfig::set_operator(account, 0x0);
    }
}
// check: EXECUTED

//! new-transaction
//! sender: bob
script {
    use 0x1::Signer;
    use 0x1::ValidatorConfig;
    fun main(account: &signer) {
        ValidatorConfig::set_operator(account, Signer::address_of(account))
    }
}
// check: EXECUTED

//! new-transaction
//! sender: bob
script {
    use 0x1::ValidatorConfig;
    // delegate to alice
    fun main(account: &signer) {
        ValidatorConfig::set_operator(account, {{alice}});
        ValidatorConfig::remove_operator(account);
    }
}
// check: EXECUTED

//! new-transaction
//! sender: bob
script {
    use 0x1::ValidatorConfig;
    fun main(account: &signer) {
        ValidatorConfig::set_config(account, {{vivian}},
                                    x"d75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a",
                                    x"", x"", x"", x"");
    }
}
// TODO(status_migration) remove duplicate check
// check: ABORTED
// check: ABORTED
// check: 1

//! new-transaction
//! sender: bob
script {
    use 0x1::ValidatorConfig;
    fun main(account: &signer) {
        ValidatorConfig::set_config(account, {{vivian}}, x"d75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a", x"", x"", x"", x"");
    }
}
// TODO(status_migration) remove duplicate check
// check: ABORTED
// check: ABORTED
// check: 1
