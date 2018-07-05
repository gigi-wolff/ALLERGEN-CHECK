def process_ingredients_string(ingredients)
    # [^xyz] matches everything that is not enclosed in brackets
    # get rid of all characters that are not: a-z A-Z 0-9 - [] () . ' / , blank;
    ingredients = ingredients.gsub(%r{[^a-zA-Z0-9\-\[\]\.\,\'\(\)\/\s]}, '')

    # replace '(' with ', ' and ')' with ',' to get at ingredients inside of ()
    # so that 'xyz (a,b,c)' ---> 'xyz, a, b, c,'
    ingredients = ingredients.gsub('(', ', ').delete(')')

    # replace '/' with ', '  'water/eau ---> water, eau'
    ingredients.gsub!('/',', ')

    # WATCH OUT FOR INGREDIENTS LIKE p,p'-Diaminodifenylmethan
    # DON'T AUTOMATICALLY ADD A SPACE BETWEEN 2 CHARACATERS 
    #ingredients.scan(/[a-z],[A-Z]/) { |match| match.gsub!(',', ', ') }

    # split ingredients seperated ', '
    ingredients = ingredients.split(', ')

    # delete all empty strings in ingredients list
    ingredients.delete_if { |ingredient| ingredient == "" }

    # strip leading and trailing blanks " abc " ---> "abc"
    product_ingredients = ingredients.each { |ingredient| ingredient.strip! } 

    return product_ingredients
end
