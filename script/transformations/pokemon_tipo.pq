// pokemon_bruto
let
    Fonte = Python.Execute("import requests#(lf)import pandas as pd#(lf)#(lf)# URL base da API#(lf)url = ""https://pokeapi.co/api/v2/pokemon?limit=500""#(lf)#(lf)# Converte a resposta em dicionário#(lf)response = requests.get(url).json()#(lf)pokemon_list = response['results']#(lf)#(lf)# Lista para armazenar os dados#(lf)data = []#(lf)#(lf)# Loop para pegar os detalhes de cada Pokémon#(lf)for pokemon in pokemon_list:#(lf)    details = requests.get(pokemon['url']).json()#(lf)    #(lf)    # Obtém todos os atributos importantes#(lf)    data.append({#(lf)        'ID': details['id'],#(lf)        'Nome': details['name'],#(lf)        'Altura': details['height'],#(lf)        'Peso': details['weight'],#(lf)        'Base XP': details['base_experience'],#(lf)        'Tipos': ', '.join(t['type']['name'] for t in details['types']),  # Lista de tipos#(lf)        'Habilidades': ', '.join(a['ability']['name'] for a in details['abilities']),  # Lista de habilidades#(lf)        'HP': details['stats'][0]['base_stat'],#(lf)        'Ataque': details['stats'][1]['base_stat'],#(lf)        'Defesa': details['stats'][2]['base_stat'],#(lf)        'Velocidade': details['stats'][5]['base_stat'],#(lf)        'Sprite (2D)': details['sprites']['front_default']#(lf)    })#(lf)#(lf)# Cria DataFrame#(lf)pokemon_bruto = pd.DataFrame(data)#(lf)#(lf)# Retorna o DataFrame#(lf)pokemon_bruto#(lf)"),
    #"Value Expandido" = Table.ExpandTableColumn(Fonte, "Value", {"ID", "Nome", "Altura", "Peso", "Base XP", "Tipos", "Habilidades", "HP", "Ataque", "Defesa", "Velocidade", "Sprite (2D)"}, {"Value.ID", "Value.Nome", "Value.Altura", "Value.Peso", "Value.Base XP", "Value.Tipos", "Value.Habilidades", "Value.HP", "Value.Ataque", "Value.Defesa", "Value.Velocidade", "Value.Sprite (2D)"}),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Value Expandido",{{"Value.ID", "ID"}, {"Value.Nome", "Nome"}, {"Value.Altura", "Altura"}, {"Value.Peso", "Peso"}, {"Value.Base XP", "Base XP"}, {"Value.Tipos", "Tipos"}, {"Value.Habilidades", "Habilidades"}, {"Value.HP", "HP"}, {"Value.Ataque", "Ataque"}, {"Value.Defesa", "Defesa"}, {"Value.Velocidade", "Velocidade"}, {"Value.Sprite (2D)", "Sprite (2D)"}}),
    #"Colunas Reordenadas" = Table.ReorderColumns(#"Colunas Renomeadas",{"ID", "Name", "Nome", "Altura", "Peso", "Base XP", "Tipos", "Habilidades", "HP", "Ataque", "Defesa", "Velocidade", "Sprite (2D)"}),
    #"Colunas Removidas" = Table.RemoveColumns(#"Colunas Reordenadas",{"Name"})
in
    #"Colunas Removidas"

// pokemon_tipo
let
    Fonte = pokemon_bruto,
    #"Colunas Removidas" = Table.RemoveColumns(Fonte,{"Nome", "Altura", "Peso", "Base XP", "Habilidades", "HP", "Ataque", "Defesa", "Velocidade", "Sprite (2D)"}),
    #"Dividir Coluna por Delimitador" = Table.SplitColumn(#"Colunas Removidas", "Tipos", Splitter.SplitTextByDelimiter(", ", QuoteStyle.Csv), {"Tipos.1", "Tipos.2"}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Dividir Coluna por Delimitador",{{"Tipos.1", type text}, {"Tipos.2", type text}}),
    #"Colunas Não Dinâmicas" = Table.UnpivotOtherColumns(#"Tipo Alterado", {"ID"}, "Atributo", "Valor"),
    #"Colunas Removidas1" = Table.RemoveColumns(#"Colunas Não Dinâmicas",{"Atributo"}),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Colunas Removidas1",{{"Valor", "Tipo"}})
in
    #"Colunas Renomeadas"