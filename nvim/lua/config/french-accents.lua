-- French accent auto-correction for markdown files
-- This module provides automatic accent insertion for common French words

local M = {}

-- Common French words that need accents
local french_corrections = {
  -- À
  ["a"] = "à",

  -- É words
  ["ecole"] = "école",
  ["etudiant"] = "étudiant",
  ["etudiante"] = "étudiante",
  ["etudiants"] = "étudiants",
  ["etudiantes"] = "étudiantes",
  ["ete"] = "été",
  ["etre"] = "être",
  ["etat"] = "état",
  ["etats"] = "états",
  ["energie"] = "énergie",
  ["electricite"] = "électricité",
  ["economie"] = "économie",
  ["ecologique"] = "écologique",
  ["edification"] = "édification",
  ["edition"] = "édition",
  ["education"] = "éducation",
  ["eleve"] = "élève",
  ["eleves"] = "élèves",
  ["emotion"] = "émotion",
  ["emotions"] = "émotions",
  ["equipe"] = "équipe",
  ["equipes"] = "équipes",
  ["evenement"] = "événement",
  ["evenements"] = "événements",

  -- È words
  ["tres"] = "très",
  ["apres"] = "après",
  ["pres"] = "près",
  ["succes"] = "succès",
  ["proces"] = "procès",
  ["acces"] = "accès",
  ["progres"] = "progrès",
  ["interet"] = "intérêt",
  ["foret"] = "forêt",
  ["fenetre"] = "fenêtre",
  ["fenetres"] = "fenêtres",

  -- Ç words
  ["francais"] = "français",
  ["francaise"] = "française",
  ["francaises"] = "françaises",
  ["lecon"] = "leçon",
  ["lecons"] = "leçons",
  ["garcon"] = "garçon",
  ["garcons"] = "garçons",
  ["facade"] = "façade",
  ["facades"] = "façades",

  -- Ô words
  ["role"] = "rôle",
  ["roles"] = "rôles",
  ["hotel"] = "hôtel",
  ["hotels"] = "hôtels",
  ["hopital"] = "hôpital",
  ["hopitaux"] = "hôpitaux",

  -- Î words
  ["meme"] = "même",
  ["memes"] = "mêmes",
  ["maitre"] = "maître",
  ["maitres"] = "maîtres",
  ["maitresse"] = "maîtresse",
  ["maitresses"] = "maîtresses",

  -- Ù words
  ["ou"] = "où", -- Only when asking "where"

  -- Other common words (removed hyphenated words for now)
  ["deja"] = "déjà",
  ["plutot"] = "plutôt",
  ["bientot"] = "bientôt",
  ["aussitot"] = "aussitôt",
  ["numero"] = "numéro",
  ["numeros"] = "numéros",
  ["telephone"] = "téléphone",
  ["telephones"] = "téléphones",
  ["televiseur"] = "téléviseur",
  ["televiseurs"] = "téléviseurs",
  ["television"] = "télévision",
  ["televisions"] = "télévisions",
  ["theatre"] = "théâtre",
  ["theatres"] = "théâtres",
  ["litterature"] = "littérature",
  ["bibliotheque"] = "bibliothèque",
  ["bibliotheques"] = "bibliothèques",
  ["musee"] = "musée",
  ["musees"] = "musées",
  ["cafe"] = "café",
  ["cafes"] = "cafés",
  ["bebe"] = "bébé",
  ["bebes"] = "bébés",
  ["pere"] = "père",
  ["peres"] = "pères",
  ["mere"] = "mère",
  ["meres"] = "mères",
  ["frere"] = "frère",
  ["freres"] = "frères",
  ["premiere"] = "première",
  ["premieres"] = "premières",
  ["derniere"] = "dernière",
  ["dernieres"] = "dernières",
  ["lumiere"] = "lumière",
  ["lumieres"] = "lumières",
  ["riviere"] = "rivière",
  ["rivieres"] = "rivières",
  ["maniere"] = "manière",
  ["manieres"] = "manières",
  ["matiere"] = "matière",
  ["matieres"] = "matières",
}

-- Function to set up French abbreviations for the current buffer
function M.setup_french_abbreviations()
  if vim.bo.filetype ~= "markdown" then
    return
  end

  for wrong, correct in pairs(french_corrections) do
    -- Create insert mode abbreviations using Neovim's keymap API
    -- This is more robust than vim.cmd
    vim.keymap.set("ia", wrong, correct, {
      buffer = true,
      desc = "French accent correction: " .. wrong .. " → " .. correct,
    })
  end
end

-- Function to manually correct the word under cursor
function M.correct_word_under_cursor()
  local word = vim.fn.expand("<cword>")
  local lower_word = string.lower(word)

  if french_corrections[lower_word] then
    local correction = french_corrections[lower_word]
    -- Preserve original case
    if word:match("^%u") then
      correction = correction:gsub("^%l", string.upper)
    end

    -- Replace the word
    vim.cmd("normal! ciw" .. correction)
    print("Corrected: " .. word .. " → " .. correction)
  else
    print("No correction found for: " .. word)
  end
end

-- Function to add a custom french word correction
function M.add_correction(wrong, correct)
  french_corrections[wrong] = correct
  if vim.bo.filetype == "markdown" then
    vim.cmd(string.format("iabbrev <buffer> %s %s", wrong, correct))
  end
end

return M
