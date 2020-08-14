import sequtils
import options

import norm/model


type
  Toy* = ref object of Model
    price*: float

  Pet* = ref object of Model
    species*: string
    favToy*: Toy

  Person* = ref object of Model
    name*: string
    pet*: Option[Pet]

  PetPerson* = ref object of Model
    pet*: Pet
    person*: Person

func newToy*(price: float): Toy =
  Toy(price: price)

func newToy*(): Toy = newToy(0.0)

func `===`*(a, b: Toy): bool =
  a[] == b[]

func newPet*(species: string, favToy: Toy): Pet =
  Pet(species: species, favToy: favToy)

func newPet*(): Pet = newPet("", newToy())

func `===`*(a, b: Pet): bool =
  a.species == b.species and
  a.favToy === b.favToy

func `===`*(a, b: Option[Pet]): bool =
  (a.isNone and b.isNone) or
  (a.isSome and b.isSome and get(a).species == get(b).species and
  get(a).favToy === get(b).favToy)

func newPerson*(name: string, pet: Option[Pet]): Person =
  Person(name: name, pet: pet)

func newPerson*(name: string, pet: Pet): Person =
  Person(name: name, pet: some pet)

func newPerson*(): Person = newPerson("", newPet())

func `===`*(a, b: Person): bool =
  a.name == b.name and
  a.pet === b.pet

proc doublePrice*(toy: var Toy) =
  toy.price *= 2

func newPetPerson*(pet: Pet, person: Person): PetPerson =
  PetPerson(pet: pet, person: person)

func newPetPerson*(): PetPerson =
  newPetPerson(newPet(), newPerson())

func `===`*(a, b: PetPerson): bool =
  a.pet === b.pet and
  a.person === b.person

func `===`*[T: Toy | Pet | Person | PetPerson](a, b: openArray[T]): bool =
  zip(a, b).allIt(it[0] === it[1])
