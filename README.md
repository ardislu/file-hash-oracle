# file-hash-oracle

File hashes are commonly used to confirm the integrity of a file.

By comparing the hash of a file against a trusted source, you can validate that the file you have was not corrupted or tampered with by a malicious or compromised file host.

This repo contains a proof of concept to use a smart contract on the Ethereum blockchain as the "trusted source" for file hashes.

## Static analysis

Install [c4udit](https://github.com/byterocket/c4udit) and [slither](https://github.com/crytic/slither) for static analysis on the smart contract (to catch gas optimizations, best practices, etc.).

Run c4udit:

```
c4udit ./contracts/FileHashOracle.sol
```

Run slither:

```
slither ./contracts/FileHashOracle.sol 
```

## Testing

Install [Echidna](https://github.com/crytic/echidna) for testing the smart contract.

Run Echidna:

```
echidna-test ./contracts/Echidna.sol --contract Echidna --config echidna.yaml
```

## Deploying

Use [`solc`](https://docs.soliditylang.org/en/latest/installing-solidity.html) to compile `FileHashOracle.sol`:

```
solc ./contracts/FileHashOracle.sol --bin
```

Then send the bytecode to a JSON-RPC node to deploy it. For example, copy this code into a web browser's DevTools console to deploy the contract using MetaMask:

```javascript
await ethereum.request({
  method: 'eth_sendTransaction',
  params: [{
    from: (await ethereum.request({ method: 'eth_requestAccounts' }))[0], // Your currently active address
    data: '0x608060...' // Replace with the bytecode from solc
  }]
});
```

## Using the oracle

You can use the [example frontend](https://filehashoracle.ardis.lu/) to verify files.

Or, you can interact with the smart contract directly. First, hash the file...

Using PowerShell:

```powershell
PS> Get-FileHash baby.gif

Algorithm       Hash                                                                   Path
---------       ----                                                                   ----
SHA256          5657105BCD9EEE10B2330F8E1325284435D92028897B589BEA7BBA66BD3C3C24       baby.gif
```

Using bash:

```bash
$ sha256sum baby.gif

5657105bcd9eee10b2330f8e1325284435d92028897b589bea7bba66bd3c3c24  baby.gif
```

Then send a call to a JSON-RPC endpoint to talk to the [smart contract deployed on Sepolia](https://sepolia.etherscan.io/address/0x50469b0edb169DC779786cC87EE6E09bA1D224CB)...

Using the [Etherscan UI](https://sepolia.etherscan.io/address/0x50469b0edb169DC779786cC87EE6E09bA1D224CB#readContract), or manually using JavaScript:

```javascript
await fetch('https://eth.ardis.lu/v1/sepolia', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    jsonrpc: '2.0',
    id: 1,
    method: 'eth_call',
    params: [
      {
        to: '0x50469b0edb169DC779786cC87EE6E09bA1D224CB',
        data: '0x6a9385675657105bcd9eee10b2330f8e1325284435d92028897b589bea7bba66bd3c3c24' // 6a938567 = function byte signature for isValid(bytes32)
      },
      'latest'
    ]
  })
})
  .then(r => r.json())
  .then(obj => obj['result'])
  .then(result => Boolean(parseInt(result, 16)));
```

## Similar projects

- [Branch Blockchain - Raid 1: Create a signing service](https://github.com/01-edu/Branch-Blockchain/)
- [Notary](https://etherscan.io/address/0x62700146f115fe08ca37be4a3a91935b28dfbc08#code) (used for [Perpetual Powers of Tau](https://github.com/privacy-scaling-explorations/perpetualpowersoftau))
