from pathlib import Path
import requests
import pandas as pd

# URL base da API
url = "https://pokeapi.co/api/v2/pokemon?limit=500"

# Converte a resposta em dicionário
response = requests.get(url).json()
pokemon_list = response['results']

# Lista para armazenar os dados
data = []

# Loop para pegar os detalhes de cada Pokémon
for pokemon in pokemon_list:
    details = requests.get(pokemon['url']).json()
    
    # Obtém todos os atributos importantes
    data.append({
        'ID': details['id'],
        'Nome': details['name'],
        'Altura': details['height'],
        'Peso': details['weight'],
        'Base XP': details['base_experience'],
        'Tipos': ', '.join(t['type']['name'] for t in details['types']),  # Lista de tipos
        'Habilidades': ', '.join(a['ability']['name'] for a in details['abilities']),  # Lista de habilidades
        'HP': details['stats'][0]['base_stat'],
        'Ataque': details['stats'][1]['base_stat'],
        'Defesa': details['stats'][2]['base_stat'],
        'Velocidade': details['stats'][5]['base_stat'],
        'Sprite (2D)': details['sprites']['front_default']
    })

# Cria DataFrame
pokemon_bruto = pd.DataFrame(data)

# Retorna o DataFrame
pokemon_bruto
