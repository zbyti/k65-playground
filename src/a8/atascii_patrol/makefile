K65=${K65_HOME}/bin/k65

all: main

main:
	$(K65) @main.k65proj

save:
	cp /dev/shm/main.xex bin/game.xex

pack:
	exomizer sfx sys -n -t 168 -o bin/atascii_patrol.xex /dev/shm/main.xex