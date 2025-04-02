// pokemon_bruto
let
    Fonte = Python.Execute("import requests#(lf)import pandas as pd#(lf)#(lf)# URL base da API#(lf)url = ""https://pokeapi.co/api/v2/pokemon?limit=1000""#(lf)#(lf)# Converte a resposta em dicionário#(lf)response = requests.get(url).json()#(lf)pokemon_list = response['results']#(lf)data = []#(lf)#(lf)# Loop para pegar os detalhes de cada Pokémon#(lf)for pokemon in pokemon_list:#(lf)    details = requests.get(pokemon['url']).json()#(lf)    data.append({#(lf)        'ID': details['id'],#(lf)        'Nome': details['name'],#(lf)        'Altura': details['height'],#(lf)        'Peso': details['weight'],#(lf)        'Base XP': details['base_experience'],#(lf)        'Tipos': ', '.join(t['type']['name'] for t in details['types']),#(lf)        'Habilidades': ', '.join(a['ability']['name'] for a in details['abilities']),#(lf)        'HP': details['stats'][0]['base_stat'],#(lf)        'Ataque': details['stats'][1]['base_stat'],#(lf)        'Defesa': details['stats'][2]['base_stat'],#(lf)        'Velocidade': details['stats'][5]['base_stat'],#(lf)        'Sprite (2D)': details['sprites']['front_default'],#(lf)        'Sprite HD': details['sprites']['other']['official-artwork']['front_default'],#(lf)        'Sprite Shiny': details['sprites']['front_shiny']#(lf)    })#(lf)#(lf)# Cria DataFrame#(lf)pokemon_bruto = pd.DataFrame(data)#(lf)pokemon_bruto#(lf)"),
    pokemon_bruto1 = Fonte{[Name="pokemon_bruto"]}[Value],
    #"Tipo Alterado" = Table.TransformColumnTypes(pokemon_bruto1,{{"ID", Int64.Type}, {"Altura", Int64.Type}, {"Peso", Int64.Type}, {"Base XP", Int64.Type}, {"HP", Int64.Type}, {"Ataque", Int64.Type}, {"Defesa", Int64.Type}, {"Velocidade", Int64.Type}})
in
    #"Tipo Alterado"

// pokemon_tipo
let
    Fonte = pokemon_bruto,
    #"Colunas Removidas" = Table.RemoveColumns(Fonte,{"Nome", "Altura", "Peso", "Base XP", "Habilidades", "HP", "Ataque", "Defesa", "Velocidade", "Sprite (2D)", "Sprite HD", "Sprite Shiny"}),
    #"Dividir Coluna por Delimitador" = Table.SplitColumn(#"Colunas Removidas", "Tipos", Splitter.SplitTextByDelimiter(", ", QuoteStyle.Csv), {"Tipos.1", "Tipos.2"}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Dividir Coluna por Delimitador",{{"Tipos.1", type text}, {"Tipos.2", type text}}),
    #"Colunas Não Dinâmicas" = Table.UnpivotOtherColumns(#"Tipo Alterado", {"ID"}, "Atributo", "Valor"),
    #"Colunas Removidas1" = Table.RemoveColumns(#"Colunas Não Dinâmicas",{"Atributo"}),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Colunas Removidas1",{{"Valor", "Tipo"}})
in
    #"Colunas Renomeadas"