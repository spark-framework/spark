from quake3rcon.rcon import Rcon

rcon = Rcon('127.0.0.1', 30120, 'DeinWunschRconPasswort') # Connecting to RCON

responce = rcon.send('__spark_rcon daddy farmand') # Send RCON command
print(responce)