# Stacks Inheritence Contract

A smart contract for inheritence planning on Bitcoin secured Stacks blockchain.

```
├── contracts
├──── inheritence.clar
├── settings
├── tests
├── .gitignore
├── Clarinet.toml
├── README.md
```

## WARNING
The `inheritence.clar` Clarity code for inheritence smart contract has not been tested! Use with caution. Do your own research. The code comes with no warranty! 

## Purpose
You can use `inheritence.clar` Clarity code to deploy a Stacks blockchain contract for inheritence purposes. The contract address acts as custodian that holds STX funds that can be claimed by beneficiary after a pre-specified time has passed, or by deployer at any time. 

## Dependencies for local testing
It is recommended you try the Clarity smart contract locally using _clarinet_. 

There are two ways to get Clarinet.

The first way is to run the following terminal commands based on your OS:
- macOS & Linux: `brew install clarinet`
- Windows: `winget install clarinet`

## Contract main functions

| Public functions                                |
+-------------------------------------------------+
| (claim_beneficiary)                             |
| (claim_deployer)                                |
| (lock                                           |
|     (new-beneficiary principal)                 |
|     (new-unlock-minutes uint)                   |
|     (amount uint))                              |
+-------------------------------------------------+

| Read only functions                             |
+-------------------------------------------------+
| (get-beneficiary)                               |
| (get-unlock-height)                             |
| (get-unlock-minutes)                            |
| (infer-block-hight-from-minutes (minutes uint)) |
+-------------------------------------------------+

## Example commands

```
% clarinet console

>> (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.inheritence lock 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 u1000000 u10)

Events emitted
{"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.inheritence","amount":"10","memo":""}}
(ok true)


```