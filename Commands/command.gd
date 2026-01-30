# Fichier: command.gd
# Rôle: Classe de base abstraite pour le design pattern "Command".
#
# Le Command Pattern est utilisé ici pour encapsuler chaque action possible
# (déplacement, attaque, etc.) dans un objet "Commande".
#
# Avantages de cette approche:
# 1. Découplage: L'objet qui initie l'action (ex: GameBoard) n'a pas besoin de savoir
#    comment l'action est exécutée. Il crée juste une commande et l'exécute.
# 2. Gestion des tours: Permet au TurnManager et au GameBoard de traiter toutes les actions
#    de manière uniforme (simplement `command.execute()`) et d'attendre la fin de l'action
#    (`await command.finished`) avant de passer à la suite.
# 3. Extensibilité: Pour ajouter une nouvelle action, il suffit de créer une nouvelle classe
#    qui hérite de Command, sans modifier le code existant.

class_name Command extends RefCounted

# Signal émis lorsque la commande a terminé son exécution.
signal finished

# Méthode virtuelle que chaque commande concrète doit implémenter.
# C'est ici que la logique de l'action est définie.
func execute() -> void:
	push_error("execute() Must be implemented in child class")
	
