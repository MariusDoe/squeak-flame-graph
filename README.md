# Flame Graph for Squeak

## Installation

```smalltalk
Metacello new
	baseline: 'FlameGraph';
	repository: 'github://MariusDoe/squeak-flame-graph:main/src';
	get; load.
```

## Usage

```smalltalk
FlameGraph messageTallyOn: [ChangeList browseMethodVersions].
```
![screenshot of a regular message tally flame graph](./screenshots/message-tally.png)

```smalltalk
FlameGraph leftHeavyMessageTallyOn: [ChangeList browseMethodVersions].
```
![screenshot of a left-heavy message tally flame graph](./screenshots/left-heavy-message-tally.png)

```smalltalk
FlameGraph profile: [ChangeList browseMethodVersions].
```
![screenshot of a custom profile flame graph](./screenshots/profile.png)

Scroll vertically and horizontally to navigate. Use <kbd>W</kbd> to zoom in and <kbd>S</kbd> to zoom out. Left-click to browse a method, shift-left-click to inspect the captured data.

Also search for preferences named _Flame Graph_ to adjust visuals.
