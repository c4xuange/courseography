module SvgParsing.ParserUtil where

import Text.XML.HaXml
import Text.XML.HaXml.ByteStringPP
import Text.XML.HaXml.Wrappers
import Text.XML.HaXml.Types
import Text.XML.HaXml.Combinators
import Control.Monad.IO.Class  (liftIO)
import Text.XML.HaXml.Util
import Text.XML.HaXml.XmlContent.Parser
import qualified Data.Conduit.List as CL
import Database.Persist
import Database.Persist.Sqlite
import Text.XML.HaXml.Namespaces
import Data.Conduit
import Data.List.Split hiding (startsWith)
import Data.List
import Data.Text as T (pack, unpack)
import Database.Tables
import Database.JsonParser
import SvgParsing.Types

-- | Gets the root element of the document.
getRoot :: Document i -> Content i
getRoot doc = head $ parseDocument (tag "svg") doc

-- | Gets a style attribute from a style String.
getStyleAttr :: String -> String -> String
getStyleAttr attr style =
    drop (length attr + 1) $
    head $ filter (isPrefixOf $ attr ++ ":") (splitOn ";" style) ++ [""]

-- | Gets a style attribute from a style String. If the style attribute is "",
-- then this function defaults to the previous style attribute, 'parent'.
getNewStyleAttr :: String -> String -> String -> String
getNewStyleAttr newStyle attr parentStyle
    | null newAttrStyle = parentStyle
    | otherwise = newAttrStyle
    where newAttrStyle = getStyleAttr attr newStyle

-- | Applys a CFilter to a Document and produces a list of Content filtered
-- by the CFilter.
parseDocument :: CFilter i -> Document i -> [Content i]
parseDocument filter (Document _ _ e _) = filter (CElem e undefined)

-- | Gets the tag name of an Element.
getName :: Content i -> String
getName (CElem (Elem a _ _) _) = printableName a
getName _ = ""

-- | Gets the list of Attributes of an Element.
getAttrs :: Element s -> [Attribute]
getAttrs (Elem _ b _) = b

-- | Gets an Attribute's name.
getAttrName :: Attribute -> String
getAttrName (a, _) = printableName a

-- | Gets an Attribute's value.
getAttrVal :: Attribute -> String
getAttrVal (_, b) = show b

-- | Converts an Attribute into a more parsable form.
convertAttributeToTuple :: Attribute -> (String, String)
convertAttributeToTuple at = (getAttrName at, getAttrVal at)

-- | Gets the children of the current node.
getChildren :: Content i -> [Content i]
getChildren = path [children]

-- | Gets the value of the attribute with the corresponding key.
getAttribute :: String -> Content i -> String
getAttribute attr (CElem content undefined)
    | null matchingAttrs = ""
    | otherwise = getAttrVal $ head matchingAttrs
    where matchingAttrs = filter (\x -> getAttrName x == attr)
                                 (getAttrs content)
getAttribute _ _ = ""

-- | Parses a transform String into a tuple of Float.
parseTransform :: String -> Point
parseTransform transform =
    let parsedTransform = splitOn "," $ drop 10 transform
        xPos = read $ parsedTransform !! 0
        yPos = read $ init $ parsedTransform !! 1
    in (xPos, yPos)

-- | Parses a path's `d` attribute.
parsePathD :: String -> [Point]
parsePathD d
    | head d == 'm' = relCoords
    | otherwise = absCoords
    where
      lengthMoreThanOne = \x -> length x > 1
      coordList = filter lengthMoreThanOne $ map (splitOn ",") $ splitOn " " d
      -- Converts a relative coordinate structure into an absolute one.
      relCoords = tail $ foldl (\x y -> x ++ [addTuples (convertToPoint y) (last x)])
                               [(0,0)]
                               coordList
      -- Converts a relative coordinate structure into an absolute one.
      absCoords = map convertToPoint coordList
      convertToPoint y = (read (head y), read (last y))

-- | Adds two tuples together.
addTuples :: Point -> Point -> Point
addTuples (a,b) (c,d) = (a + c, b + d)

-- | Determines if a point intersects with a shape.
intersects :: Double -> Double -> Point -> Double -> Point -> Bool
intersects width height (rx, ry) offset (px, py) =
    let dx = px - rx
        dy = py - ry
    in dx >= -1 * offset &&
       dx <= width + offset &&
       dy >= -1 * offset &&
       dy <= height + offset;