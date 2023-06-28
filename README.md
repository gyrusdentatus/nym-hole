# nym-hole

## Send files over mixnet securely from A to B with zero knowledge

nym-hole is a bash script that allows you to securely send files over a mixnet from one point to another with zero knowledge. It's built on top of [Croc](https://github.com/schollz/croc) and Magic-wormhole, and additionally uses the Nym mixnet over a socks5 proxy.

### Prerequisites:

- Croc https://github.com/schollz/croc (follow the instructions if using MacOS - if on Linux, it will download and install it automatically after consent)
- nym-socks5-client (you have to have nym-socks5-client running or the binaries in your PATH at least, else the script can't run at this early stage)
- Linux recommended (install with **brew** on MacOS as per instructions from **Croc**)

### Usage:

```bash
bash nym-hole.sh [OPTIONS] FILE

Options:

--relay RELAY: Use a custom relay for croc.
--test: Check if croc and nym-socks5-client are installed and running.
--install: Install nym-socks5-client.
--service-provider SP: Use a custom service provider for nym.
--dry-test: Run croc without --socks and --relay flags.
--help: Print a help message.

```
### MACHINE A (sender)
<img width="467" alt="image" src="https://github.com/gyrusdentatus/nym-hole/assets/33793809/947d5b89-453e-4dfd-b491-73c211b5f081">

### MACHINE B (recipient)

<img width="846" alt="image" src="https://github.com/gyrusdentatus/nym-hole/assets/33793809/bfcb6edb-63bb-4e63-9f3b-afdc49b6a93a">

## Important notes: 

- this is a very hacky and early version and is not properly tested. 
- if you want the recipient to receive the file, they need to add `--socks5 "127.0.0.1:1080"` after you send them the output when sending a file. It looks like this: `croc --socks5 "127.0.0.1:1080" --relay 37.235.105.22:9009 8361-picnic-spirit-native` 
- NYM Mixnet has its limitations and stuff might not work, so make sure you first check if you can run your own RELAY and SERVICE-PROVIDER before you make any complaints.
- NYM service-provider has to have the `--relay` IP addr or hostname in `allowed.list` otherwise it will obviously not work unless you are running an *open-proxy* 
## Acknowledgments
### nym-hole is built on top of Croc, a tool developed by Zack Schollz.
https://github.com/schollz/croc Thanks for a great tool and alternative to *magic-wormhole* !!!


Many thanks to all those who have contributed to Croc:

@warner for the idea
@tscholl2 for the encryption gists
@skorokithakis for code on proxying two connections
And to everyone who has made pull requests: @maximbaz, @meyermarcel, @Girbons, @techtide, @heymatthew, @Lunsford94, @lummie, @jesuiscamille, @threefjord, @marcossegovia, @csleong98, @afotescu, @callmefever, @El-JojA, @anatolyyyyyy, @goggle, @smileboywtu, @nicolashardy, @fbartels, @rkuprov, @hreese, @xenrox, and @Ipar.

## License
nym-hole is distributed under the MIT license. For more details, see the LICENSE file in the repository.
