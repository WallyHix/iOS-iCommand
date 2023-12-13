//
//  MessageCard.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 6.06.2023.
//

import SwiftUI
import MarkdownUI
import UniformTypeIdentifiers

struct MessageCard: View {
    var message: MessageModel
    
    var body: some View {
        VStack()
        {
            if message.isUserMessage
            {
                let output = (message.content as! String)
                HumanMessageCard(message: output)
            }else
            {
                let output = (message.content as! String)
                BotMessageCard(message: output)
            }
        }
        .frame(maxWidth: .infinity,alignment: message.isUserMessage ? .trailing : .leading)
        .padding(.trailing, message.isUserMessage ? 0 : 10)
        .padding(.leading, message.isUserMessage ? 10 : 0)
        .padding(.vertical, 4)
        
    }
}

struct HumanMessageCard : View
{
    var message : String = ""
    
    var body: some View{
        ZStack
        {
            Text(message).padding(.vertical, 12).padding(.horizontal, 18).multilineTextAlignment(.trailing).foregroundColor(.white)  .modifier(UrbanistFont(.medium, size: 18))
        }.background(
            Color.green_color
        ).cornerRadius(13, corners: [.topLeft, .bottomRight, .bottomLeft]).cornerRadius(5, corners: [.topRight])
        
    }
}

struct BotMessageCard : View
{
    var message : String = ""
    @State private var isShare = false
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    var body: some View{
        
        Markdown(message).padding(.vertical, 12).padding(.horizontal, 18).multilineTextAlignment(.leading).foregroundColor(.text_color)  .modifier(UrbanistFont(.medium, size: 16)).background(
            Color.message_background
        ).cornerRadius(13, corners: [.topRight, .bottomRight, .bottomLeft])
            .cornerRadius(5, corners: [.topLeft])
            .markdownTextStyle(\.text)
            {
                FontFamilyVariant(.normal)
            }
            .markdownBlockStyle(\.codeBlock) { configuration in
                
                configuration.label
                    .padding()
                    .markdownTextStyle {
                        FontFamilyVariant(.normal)
                        BackgroundColor(nil)
                        ForegroundColor(.white)
                    }.foregroundColor(.white).modifier(UrbanistFont(.bold, size: 25))
                    .background( RoundedRectangle(cornerRadius: 8)
                        .fill(Color.code_background))
            }.contextMenu {
                Button {
                    UIPasteboard.general.setValue(message,
                                forPasteboardType: UTType.plainText.identifier)

                } label: {
                    Label("copy".localize(language), systemImage: "doc.on.doc")
                }

                Button {
                    isShare = true
                    
                } label: {
                    Label("share".localize(language), systemImage: "square.and.arrow.up")
                }
            } .background(SharingViewController(isPresenting: $isShare) {
                let url = message
                let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                 
                 // For iPad
                 if UIDevice.current.userInterfaceIdiom == .pad {
                    av.popoverPresentationController?.sourceView = UIView()
                 }

                av.completionWithItemsHandler = { _, _, _, _ in
                       isShare = false // required for re-open !!!
                   }
                   return av
               })
        
        
        
    }
}

struct SharingViewController: UIViewControllerRepresentable {
    @Binding var isPresenting: Bool
    var content: () -> UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresenting {
            uiViewController.present(content(), animated: true, completion: nil)
        }
    }
}

struct MessageCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            MessageCard(message: MessageModel(content: """

---
__Advertisement :)__

- __[pica](https://nodeca.github.io/pica/demo/)__ - high quality and fast image
  resize in browser.
- __[babelfish](https://github.com/nodeca/babelfish/)__ - developer friendly
  i18n with plurals support and easy syntax.

You will like those projects!

---

# h1 Heading 8-)
## h2 Heading
### h3 Heading
#### h4 Heading
##### h5 Heading
###### h6 Heading


## Horizontal Rules

___

---

***


## Typographic replacements

Enable typographer option to see result.

(c) (C) (r) (R) (tm) (TM) (p) (P) +-

test.. test... test..... test?..... test!....

!!!!!! ???? ,,  -- ---

"Smartypants, double quotes" and 'single quotes'


## Emphasis

**This is bold text**

__This is bold text__

*This is italic text*

_This is italic text_

~~Strikethrough~~


## Blockquotes


> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.


## Lists

Unordered

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


## Code

Inline `code`

Indented code

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code


Block code "fences"

```
Sample text here...
```

Syntax highlighting

``` js
var foo = function (bar) {
  return bar++;
};

console.log(foo(5));
```

## Tables

| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |

Right aligned columns

| Option | Description |
| ------:| -----------:|
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |


## Links

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")

Autoconverted link https://github.com/nodeca/pica (enable linkify to see)


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a reference later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"


## Plugins

The killer feature of `markdown-it` is very effective support of
[syntax plugins](https://www.npmjs.org/browse/keyword/markdown-it-plugin).


### [Emojies](https://github.com/markdown-it/markdown-it-emoji)

> Classic markup: :wink: :crush: :cry: :tear: :laughing: :yum:
>
> Shortcuts (emoticons): :-) :-( 8-) ;)

see [how to change output](https://github.com/markdown-it/markdown-it-emoji#change-output) with twemoji.


### [Subscript](https://github.com/markdown-it/markdown-it-sub) / [Superscript](https://github.com/markdown-it/markdown-it-sup)

- 19^th^
- H~2~O




++Inserted text++



==Marked text==


### [Footnotes](https://github.com/markdown-it/markdown-it-footnote)

Footnote 1 link[^first].

Footnote 2 link[^second].

Inline footnote^[Text of inline footnote] definition.

Duplicated footnote reference[^second].

[^first]: Footnote **can have markup**

    and multiple paragraphs.

[^second]: Footnote text.


### [Definition lists](https://github.com/markdown-it/markdown-it-deflist)

Term 1

:   Definition 1
with lazy continuation.

Term 2 with *inline markup*

:   Definition 2

        { some code, part of Definition 2 }

    Third paragraph of definition 2.

_Compact style:_

Term 1
  ~ Definition 1

Term 2
  ~ Definition 2a
  ~ Definition 2b


### [Abbreviations](https://github.com/markdown-it/markdown-it-abbr)

This is HTML abbreviation example.

It converts "HTML", but keep intact partial entries like "xxxHTMLyyy" and so on.

*[HTML]: Hyper Text Markup Language

### [Custom containers](https://github.com/markdown-it/markdown-it-container)

::: warning
*here be dragons*
:::

""", type: .text, isUserMessage: false, conversationId: "123"))
        }
    }
}
