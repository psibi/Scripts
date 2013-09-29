module BinaryTree where

data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Eq, Show, Read)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node a left right)
  | a < x = Node a left (treeInsert x right)
  | a > x = Node a (treeInsert x left) right
  | a == x = Node a left right

treeElem :: (Ord a) => a -> Tree a -> Bool
treeElem x EmptyTree = False
treeElem x (Node a left right)
  | x == a = True
  | a < x  = treeElem x left
  | a > x  = treeElem x right

instance Functor Tree where
  fmap f EmptyTree = EmptyTree
  fmap f (Node x left right) = Node (f x) (fmap f left) (fmap f right)
