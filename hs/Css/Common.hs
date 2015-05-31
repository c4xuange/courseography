{-# LANGUAGE OverloadedStrings #-}

module Css.Common where

import Clay
import Prelude hiding ((**))
import Data.Monoid
import Css.Constants

{- common
 - Generates CSS common to all pages. -}
common :: Css
common = do
    html ?
        do margin0
           padding0
           width100
           height100
           overflowY auto
    body ?
        do margin0
           padding0
           width100
           minHeight $ pct 100
           fontSize $ pt 16
           fontFamily ["Trebuchet MS", "Arial"] [sansSerif]
    headerCSS
    aDefaultCSS
    disclaimerCSS
    modalCSS

{- headerCSS
 - Generates the CSS for the header located at the top
 - of every page -}
headerCSS :: Css
headerCSS = do
    ".header" ?
        do margin0
           padding 0 (em 0.5) 0 (em 0.5)
           backgroundColor $ blue1
           color white
           h2 ?
             do fontSize $ em 1.6
                textAlign $ alignSide sideLeft
                width $ px 200
                display inlineBlock
                margin (px 10) 0 (px 5) 0
           height (px 50)
    "#nav-links" ?
        do
            "list-style" -: "none"
            minWidth $ pct 50
            margin nil nil nil nil
            display inlineBlock
            a ?
              do fontWeight normal
            li <? do
                textAlign $ alignSide sideCenter
                display inlineBlock
                padding 0 (px 10) 0 (px 10)
                a <? do
                    color white
                    hover & do
                        color gray
            height (px 50)
    "#nav-fb" ? do
        float floatRight
        height (px 50)
        "#nav-fb-post" ? do
            backgroundColor blueFb
            height (px 40)
            margin (px 5) (px 10) (px 5) (px 10)
            padding nil (px 5) nil (px 5)
            lineHeight (px 40)
            verticalAlign middle
            display none
            a <? do
                color white
            borderRadius (px 3) (px 3) (px 3) (px 3)
            cursor pointer
        ".fb-login-button" ? do
            height (px 40)
            verticalAlign middle
            width (px 140)
            overflow hidden
            margin (px 5) nil (px 5) nil

{- aDefaultCSS
 - Generates default CSS. -}
aDefaultCSS :: Css
aDefaultCSS = do
    a <> a # hover <> a # visited <> a # active ? do
        fontWeight bold
        textDecoration none
        color $ parse "#4C004C"

{- headers
 - Generates CSS for the header located at the top of
 - all pages. -}
headers :: Css
headers = do
    h1 ? do
        alignCenter
    h2 ? do
        alignCenter
    h3 ? do
        alignCenter
    h4 ? do
        width100
        fontSize $ em 1.1
        alignCenter
        margin (em 0.3) 0 (em 0.3) 0

{- disclaimerCSS
 - Generates CSS for the disclaimer located at the foot
 - of all pages. -}
disclaimerCSS :: Css
disclaimerCSS = "#disclaimerDiv" ? do
    padding 0 (em 1) 0 (em 1)
    fontSize (pt 11)

{- modalCSS
 - Generates CSS for the modal that appears
 - when nodes in the graph are clicked. -}
modalCSS :: Css
modalCSS = do
    ".ui-dialog" ? do
        outline solid (px 0) black
        color black
        overflowX hidden
        overflowY auto
        backgroundColor white
        boxShadow (px 8) (px 8) (px 8) black
    ".ui-widget-overlay" ? do
        height100
        width100
        position fixed
        left nil
        top nil
    ".modal" ? do
        padding (px 10) (px 25) (px 25) (px 25)
        position static
        p ? do
            fontSize (pt 12)
            margin (pt 5) 0 (pt 5) 0
            lineHeight (em 1.3)
    ".ui-dialog-titlebar" ? do
        color blue3
        cursor move
        paddingLeft (px 25)
        height (em 1.8)
        lineHeight (em 1.8)
        fontSize (em 1)
        borderBottom solid (px 1) black
    ".ui-dialog-titlebar-close" ? do
        display none
    ".ui-width-overlay" ? do
        height100
        width100
        left nil
        position fixed
        top nil
    ".ui-dialog" ? do
        tr ? do
            margin nil auto nil auto
    "#course-video-div" ? do
        margin (pt 5) 0 (pt 5) 0
        width100
        height100
    "#course-video" ? do
        width100
        height100
    fbModalCSS



fbModalCSS :: Css
fbModalCSS = do
    "#post-image" ? do
        borderRadius (px 5) (px 5) (px 5) (px 5)
        margin nil auto (px 10) auto
        maxWidth (pct 100)
    "#modal-buttons" ? do
        float floatRight
        margin (px 20) auto (px 20) auto
        ".btn" ? do
            margin nil (px 5) nil (px 5)