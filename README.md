# vx-trucking - FiveM Trucking Job for ox_core based servers

## 🔗Links

- 💾[Download](https://github.com/alenvalek/vx-trucking/archive/refs/tags/v0.1.0-alpha.zip)
- 🎥[Showcase](https://www.youtube.com/watch?v=RqIWhYhAoLE)

## Features

- Truck rental
- Truck rental tracking
- Trucking job group system
- Cargo delivery marker hitbox detection
- Reward system
- Expandable mission system
- Multi spot job setup
- Highly customizable

## Dependencies

- ox_core
- ox_inventory
- ox_banking
- ox_lib

## Summary

This resource was created solely to test out what can be achieved within ox_core.

## Adding new job location
[![image](https://github.com/user-attachments/assets/a4f665bf-77d3-42cd-9b39-c6904942c601)](https://carbon.now.sh/?bg=rgba%2874%2C144%2C226%2C1%29&t=blackboard&wt=none&l=auto&width=680&ds=false&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=56px&ph=56px&ln=false&fl=1&fm=Fira+Code&fs=13.5px&lh=152%25&si=false&es=2x&wm=false&code=%255B%27docks%27%255D%2520%253D%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520Trucks%2520%253D%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257B%2520startCost%2520%253D%2520150%252C%2520model%2520%253D%2520%27hauler%27%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257B%2520startCost%2520%253D%25200%252C%2520%2520%2520model%2520%253D%2520%27phantom%27%2520%257D%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520Trailers%2520%253D%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257B%2520model%2520%253D%2520%27trailers%27%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257B%2520model%2520%253D%2520%27trailers2%27%2520%257D%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520BossPed%2520%253D%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520model%2520%253D%2520%27s_m_m_dockwork_01%27%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520position%2520%253D%2520vec4%28152.945%252C%2520-3212.007%252C%25205.902%252C%252068.881%29%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520TrailerSpawnPosition%2520%253D%2520vec4%28180.326%252C%2520-3208.302%252C%25205.628%252C%2520358.337%29%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257B%2520model%2520%253D%2520%27trailers%27%252C%2520%2520labelName%2520%253D%2520%27Trailer%27%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257B%2520model%2520%253D%2520%27trailers2%27%252C%2520labelName%2520%253D%2520%27Trailer%25202%27%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257D%252C%250A%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520Jobs%2520%253D%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%255B%2522oil_01%2522%255D%2520%253D%2520%257B%2520name%2520%253D%2520%2522Oil%2520delivery%2522%252C%2520reward%2520%253D%25201000%252C%2520position%2520%253D%2520vec4%282588.521%252C%2520414.855%252C%2520108.457%252C%2520181.234%29%252C%2520trailerType%2520%253D%2520%2522tanker2%2522%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%255B%2522wood_01%2522%255D%2520%253D%2520%257B%2520name%2520%253D%2520%2522Wood%2520delivery%2522%252C%2520reward%2520%253D%25201500%252C%2520position%2520%253D%2520vec4%28-65.248%252C%25201905.083%252C%2520196.002%252C%2520188.290%29%252C%2520trailerType%2520%253D%2520%2522trailerlogs%2522%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%255B%2522metal_01%2522%255D%2520%253D%2520%257B%2520name%2520%253D%2520%2522Metal%2520delivery%2522%252C%2520reward%2520%253D%25202000%252C%2520position%2520%253D%2520vec4%282675.063%252C%25201431.447%252C%252024.501%252C%2520268.169%29%252C%2520trailerType%2520%253D%2520%2522trailers2%2522%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%255B%2522goods_01%2522%255D%2520%253D%2520%257B%2520name%2520%253D%2520%2522Goods%2520delivery%2522%252C%2520reward%2520%253D%25202500%252C%2520position%2520%253D%2520vec4%28720.875%252C%2520-984.858%252C%252024.156%252C%2520274.363%29%252C%2520trailerType%2520%253D%2520%2522trailers3%2522%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%255B%2522goods_02%2522%255D%2520%253D%2520%257B%2520name%2520%253D%2520%2522Goods%2520delivery%25202%2522%252C%2520reward%2520%253D%25202500%252C%2520position%2520%253D%2520vec4%28-2310.149%252C%2520265.014%252C%2520169.602%252C%252022.005%29%252C%2520trailerType%2520%253D%2520%2522trailers3%2522%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%255B%2522goods_03%2522%255D%2520%253D%2520%257B%2520name%2520%253D%2520%2522Goods%2520delivery%25203%2522%252C%2520reward%2520%253D%25202500%252C%2520position%2520%253D%2520vec4%28-2310.149%252C%2520265.014%252C%2520169.602%252C%252022.005%29%252C%2520trailerType%2520%253D%2520%2522trailers3%2522%2520%257D%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520VehicleParkingSpots%2520%253D%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520vec4%28144.677%252C%2520-3210.092%252C%25206.090%252C%2520270.0%29%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520vec4%28132.568%252C%2520-3209.907%252C%25206.095%252C%2520270.0%29%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520vec4%28144.616%252C%2520-3204.009%252C%25206.093%252C%2520270.0%29%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520vec4%28132.764%252C%2520-3203.816%252C%25206.092%252C%2520270.0%29%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520vec4%28144.480%252C%2520-3196.842%252C%25206.091%252C%2520270.0%29%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520vec4%28132.946%252C%2520-3196.983%252C%25206.092)


## More coming soon
