import type { Theme } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";
import { ansiFg, ansiStyle } from "./ansi.js";
import type { RenderSegment, TokyoNightBlockName } from "./types.js";

interface TokyoNightBlock {
	name: TokyoNightBlockName;
	segments: RenderSegment[];
}

interface BlockColors {
	fg: string;
	bg: string;
}

const TOKYO_NIGHT_COLORS = {
	// Custom local theme: Rosé Pine, matching ~/.config/hypr/rose-pine.lua.
	lead: "#c4a7e7", // iris
	header: { fg: "#191724", bg: "#c4a7e7" }, // base on iris
	directory: { fg: "#191724", bg: "#ebbcba" }, // base on rose
	git: { fg: "#191724", bg: "#f6c177" }, // base on gold, avoids Rosé Pine pine/blue
	runtime: { fg: "#e0def4", bg: "#26233a" }, // text on overlay
	meter: { fg: "#e0def4", bg: "#403d52" }, // text on highlightMed
	extensionSeparator: "#c4a7e7",
} as const satisfies Record<string, string | BlockColors>;

const TOKYO_NIGHT_BLOCK_ORDER: TokyoNightBlockName[] = [
	"header",
	"directory",
	"git",
	"runtime",
	"meter",
];

export function renderTokyoNightStatusline(width: number, segments: RenderSegment[]): string {
	return truncateToWidth(joinTokyoNightSegments(segments), width, "");
}

export function tokyoNightExtensionSeparator(_theme: Theme): string {
	return ansiFg(TOKYO_NIGHT_COLORS.extensionSeparator, " • ");
}

function joinTokyoNightSegments(segments: RenderSegment[]): string {
	const blocks = groupTokyoNightBlocks(segments);
	const firstBlock = blocks.at(0);
	let line = firstBlock ? ansiFg(getTokyoNightBlockColors(firstBlock.name).bg, "") : "";

	for (const [index, block] of blocks.entries()) {
		const colors = getTokyoNightBlockColors(block.name);
		const previous =
			index === 0 ? undefined : getTokyoNightBlockColors(blocks[index - 1]?.name ?? "header");
		if (previous) line += ansiStyle("", { fg: previous.bg, bg: colors.bg });
		line += ansiStyle(formatTokyoNightBlockText(block), colors);
	}

	const lastBlock = blocks.at(-1);
	if (lastBlock) line += ansiFg(getTokyoNightBlockColors(lastBlock.name).bg, "");

	return line;
}

function groupTokyoNightBlocks(segments: RenderSegment[]): TokyoNightBlock[] {
	const blocksByName = new Map<TokyoNightBlockName, RenderSegment[]>();
	for (const segment of segments) {
		const blockSegments = blocksByName.get(segment.block) ?? [];
		blockSegments.push(segment);
		blocksByName.set(segment.block, blockSegments);
	}

	return TOKYO_NIGHT_BLOCK_ORDER.flatMap((name) => {
		const blockSegments = blocksByName.get(name);
		return blockSegments ? [{ name, segments: blockSegments }] : [];
	});
}

function formatTokyoNightBlockText(block: TokyoNightBlock): string {
	return ` ${block.segments.map(formatTokyoNightSegmentText).join(" ")}`;
}

function formatTokyoNightSegmentText(segment: RenderSegment): string {
	return segment.emphasis ? `\u001b[1m${segment.text}\u001b[22m` : segment.text;
}

function getTokyoNightBlockColors(block: TokyoNightBlockName): BlockColors {
	return TOKYO_NIGHT_COLORS[block];
}
