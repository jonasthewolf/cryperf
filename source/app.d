import jw.crypto.algorithm.chacha;

import std.conv : to;
import std.datetime;
import std.getopt;
import std.random;
import std.stdio;


chacha!(20, key!(256 / 8)) *algo;
ubyte[64] keystream; 
uint blocknumber = 0;

void InitCrypto() {
	ubyte[256/8] inkey =  0;
	auto gen = Random(unpredictableSeed);
	foreach (k ; 1 .. inkey.length) {
		inkey[k] = cast(ubyte)uniform(0, 256, gen);
	}
	const auto mykey = key!(256/8)(inkey);
	immutable nonce mynonce = [ 0x00000000, 0x00000000, 0x0 ];
	algo = new chacha!(20, key!(256 / 8))(mykey, mynonce);
}

void Encrypt() {
	algo.get_keystream(keystream, blocknumber);
	blocknumber++;
}

void Decrypt() {
	blocknumber++;
}


void main(string[] args)
{
	uint cycles = 10_000;
	auto helpInformation = getopt(args, "cycles",  &cycles); 

	if (helpInformation.helpWanted) {
		defaultGetoptPrinter("Benchmark crypto algorithms", helpInformation.options);
	}

	auto r = benchmark!(InitCrypto, Encrypt, Decrypt)(cycles);

	auto r0 = r[0] / cycles;
	auto r1 = r[1] / cycles;

	writeln(r0);
	writeln(r1);
}

