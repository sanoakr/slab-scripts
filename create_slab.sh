#!/bin/bash

dscl . -create /Users/slab
dscl . -create /Users/slab UserShell /bin/bash
dscl . -create /Users/slab RealName "Slab Common"
dscl . -create /Users/slab UniqueID 2000
dscl . -create /Users/slab PrimaryGroupID 20
dscl . -create /Users/slab NFSHomeDirectory /Users/slab

createhomedir -b -u slab
