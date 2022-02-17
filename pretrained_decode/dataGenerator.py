import os, sys

wavOrigin = sys.argv[1]
dataDir = sys.argv[2]

if not wavOrigin.endswith("/"):
    wavOrigin = wavOrigin + "/"
if not dataDir.endswith("/"):
    dataDir = dataDir + "/"

wavFiles = [f for f in os.listdir(wavOrigin) if f.endswith(".wav")]

newLines = []

for f in wavFiles:
    parts = f.rsplit(".", maxsplit=1)
    newLines.append(f"SINSPEECH_{parts[0]} {wavOrigin}{f}\n")
    
newScp = open(f"{dataDir}wav.scp", "w")
newScp.writelines(newLines)
newScp.close()

scp = open(f"{dataDir}wav.scp", "r")
allLines = scp.readlines()
scp.close()

u2sLines = []

for line in allLines:
    utt = line.strip().split()[0]
    u2sLines.append(f"{utt} global\n")
    
utt2spkFile = open(f"{dataDir}utt2spk", "w")
utt2spkFile.writelines(u2sLines)
utt2spkFile.close()