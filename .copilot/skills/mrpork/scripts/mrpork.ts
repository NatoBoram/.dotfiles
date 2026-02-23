#!/usr/bin/env node

/**
 * Generates random fantasy-style location names.
 *
 * @module
 */

const beginnings = [
	"Kr",
	"Ca",
	"Ra",
	"Rei",
	"Mar",
	"Luk",
	"Cro",
	"Cru",
	"Ray",
	"Bre",
	"Zed",
	"Mor",
	"Jag",
	"Mer",
	"Jar",
	"Mad",
	"Cry",
	"Zur",
	"Mjol",
	"Zork",
	"Creo",
	"Azak",
	"Azur",
	"Mrok",
	"Drak",
]

const middles = [
	"ir",
	"mi",
	"air",
	"sor",
	"mee",
	"clo",
	"red",
	"cra",
	"ark",
	"arc",
	"mur",
	"zer",
	"miri",
	"lori",
	"cres",
	"zoir",
	"urak",
	"marac",
	"slamar",
	"salmar",
]

const ends = [
	"d",
	"ed",
	"es",
	"er",
	"ark",
	"arc",
	"der",
	"med",
	"ure",
	"zur",
	"mur",
	"tron",
	"cred",
]

function randomFrom<T>(array: T[]): T {
	const index = Math.floor(Math.random() * array.length)
	return array[index]
}

function generateName(): string {
	const beginning = randomFrom(beginnings)
	const middle = randomFrom(middles)
	const end = randomFrom(ends)
	return `${beginning}${middle}${end}`
}

console.log(generateName())
