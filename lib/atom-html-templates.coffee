{CompositeDisposable} = require 'atom'

module.exports = AtomHtmlTemplates =
    subscriptions: null

    activate: (state) ->
        @templateForm = ""
        @additionalStyles = []
        @additionalJs = []
        @defaultStyles = '<link rel="stylesheet" href="PATH">'
        @defaultCharset = '<meta charset="UTF-8">'
        @defaultTitle = '<title>TITLE</title>'
        @defaultDescription = '<meta name="description" content="DESCRIPTION">'
        @defaultLanguage = 'en'
        # @modalPanel = atom.workspace.addModalPanel(item: @atomHtmlTemplatesView.getElement(), visible: false)

        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @subscriptions = new CompositeDisposable

        # Register command that toggles this view
        @subscriptions.add atom.commands.add 'atom-workspace', 'atom-html-templates:toggle': => @toggle()

    deactivate: ->
        @subscriptions.dispose()

    addResource: (array) ->
        indeksS = indeksJ = 0
        for i in [0...array.length] by 1
            if array[i] == 'bootstrap'
                @additionalStyles[indeksS++]= '<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">'
                @additionalJs[indeksJ++] = '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>'
            else if array[i] == 'foundation'
                @additionalStyles[indeksS++] = '<link href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.2.0/foundation.min.css" rel="stylesheet">'
                @additionalJs[indeksJ++] = '<script src="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.2.0/foundation.min.js"></script>'
            else if array[i] == 'jquery_1.12.1'
                @additionalJs[indeksJ++] = '<script src="https://code.jquery.com/jquery-1.12.1.min.js"></script>'
            else if array[i] == 'jquery_2.2.1'
                @additionalJs[indeksJ++] = '<script src="https://code.jquery.com/jquery-2.2.1.min.js"></script>'
            else if array[i] == 'fontAwesome'
                @additionalStyles[indeksS++]= '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">'
            else if array[i] == 'mdi'
                @additionalStyles[indeksS++]= '<link rel="stylesheet" href="https://cdn.materialdesignicons.com/1.4.57/css/materialdesignicons.min.css">'

    returnAdd: (array) ->
        scripts = " "
        for i in [0...array.length] by 1
            if array[i] != null||undefined
                scripts+='\n\t'
                scripts +=array[i]
        return scripts

    toggle: ->
        defaultGrammarScopeName = "text.html.basic"
        if editor=atom.workspace.getActiveTextEditor()
            value = editor.lineTextForScreenRow(editor.getLastScreenRow())
            valueArr = value.split "-"
            if valueArr != null||undefined||""
                @addResource(valueArr)
                console.log(valueArr)
                console.log(@additionalStyles)
            if valueArr[0] == "html5"
                @templateForm = """
                                <!DOCTYPE html>
                                <html lang="#{@defaultLanguage}">

                                <head>
                                    #{@defaultCharset}
                                    #{@defaultTitle}
                                    #{@defaultDescription}
                                    #{@defaultStyles}
                                    #{@returnAdd(@additionalStyles)}
                                    <!--[if lt IE 9]>
                                      <script src = "http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
                                    <![endif]-->
                                </head>

                                <body>
                                #{@returnAdd(@additionalJs)}
                                </body>

                                </html>
                                """
            else if valueArr[0] == "epub"
                @templateForm= """
                               <?xml version="1.0" encoding="UTF-8"?>
                               <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="#{@defaultLanguage}" lang="#{@defaultLanguage}">

                               <head>
                                   #{@defaultCharset}
                                   #{@defaultTitle}
                                   #{@defaultStyles}
                               </head>

                               <body epub:type="TYPE">

                               </body>

                               </html>
                                """
            else
                @templateForm="There is no such option."

        editor.setText(@templateForm)
        editor.setGrammar(atom.grammars.grammarForScopeName(defaultGrammarScopeName))

        # Refresh
        @additionalStyles = []
        @additionalJs = []
