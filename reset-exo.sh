#!/bin/bash

# --- Couleurs ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
RESET='\033[0m'
SEP="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

EXOS=(
  "2|🟦 Créer et utiliser sa branche de travail"
  "3|🟨 Faire un commit avec un message précis"
  "4|📝 Ajouter un fichier README"
  "5|🔀 Comprendre et pratiquer le merge (sans conflit)"
  "6|⚡ Vivre et résoudre un vrai conflit Git"
  "7|♻️  Pratiquer le rebase sur une feature branch"
  "8|🏷️  Taguer une version de ton code"
)

function get_tag() {
  case $1 in
    2|3|4|5)  echo "exo-base-user" ;;
    6)        echo "exo-conflit-start" ;;
    7)        echo "exo-rebase-start" ;;
    *)        echo "" ;;
  esac
}

# --- Affichage du titre ---
echo -e "${CYAN}${SEP}${RESET}"
echo -e "${BOLD}🔄 Script de reset transparent${RESET}"
echo -e "${CYAN}${SEP}${RESET}"

# --- Saisie du numéro ---
read -p "$(echo -e "${BOLD}${YELLOW}👤 Ton numéro (ex: 42) : ${RESET}")" NUM
BRANCH="user-${NUM}"

echo ""
echo -e "${BOLD}Quel exercice veux-tu lancer ?${RESET}"

for i in "${!EXOS[@]}"; do
  EXONUM="${EXOS[$i]%%|*}"
  EXOLABEL="${EXOS[$i]#*|}"
  printf "  ${YELLOW}%d)${RESET} Exercice ${BOLD}%s${RESET} : %s\n" $((i+1)) "$EXONUM" "$EXOLABEL"
done

echo ""
read -p "$(echo -e "${CYAN}👉 Tape le numéro de l'exercice : ${RESET}")" CHOICE

if ! [[ "$CHOICE" =~ ^[1-8]$ ]]; then
  echo -e "${RED}❌ Choix invalide.${RESET}"
  exit 1
fi

EXONUM="${EXOS[$((CHOICE-1))]%%|*}"
TAG_NAME=$(get_tag "$EXONUM")

if [ "$EXONUM" = "8" ]; then
  echo -e "\n${YELLOW}🏷️  Mise en place du tag exo-tag-start sur ta branche...${RESET}"
  git checkout "$BRANCH"
  git tag exo-tag-start
  git push origin exo-tag-start
  echo -e "${GREEN}✅   Tu peux maintenant commencer l'exercice 8 !${RESET}"
  exit 0
fi

if [ -z "$TAG_NAME" ]; then
  echo -e "${RED}❌ Erreur : exercice inconnu.${RESET}"
  exit 1
fi

if ! git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
  echo -e "${RED}❌ Le tag '$TAG_NAME' n'existe pas !${RESET}"
  exit 1
fi

echo -e "\n${YELLOW}⏪ Reset de ta branche '$BRANCH' vers le tag '$TAG_NAME'...${RESET}"
git checkout "$BRANCH"
git reset --hard "$TAG_NAME"

echo ""
echo -e "${GREEN}✅ Ta branche '$BRANCH' est prête pour l'exercice $EXONUM !${RESET}\n"
git status
