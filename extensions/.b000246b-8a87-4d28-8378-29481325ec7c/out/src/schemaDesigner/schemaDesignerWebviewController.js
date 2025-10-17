"use strict";
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
Object.defineProperty(exports, "__esModule", { value: true });
exports.SchemaDesignerWebviewController = void 0;
const vscode = require("vscode");
const reactWebviewPanelController_1 = require("../controllers/reactWebviewPanelController");
class SchemaDesignerWebviewController extends reactWebviewPanelController_1.ReactWebviewPanelController {
    constructor(context, vscodeWrapper, _schemaDesignerService, _database, intialSchema) {
        super(context, vscodeWrapper, "schemaDesigner", "schemaDesigner", {
            schema: intialSchema,
        }, {
            title: _database,
            viewColumn: vscode.ViewColumn.One,
            iconPath: {
                light: vscode.Uri.joinPath(context.extensionUri, "media", "visualizeSchema_light.svg"),
                dark: vscode.Uri.joinPath(context.extensionUri, "media", "visualizeSchema_dark.svg"),
            },
            showRestorePromptAfterClose: false,
        });
        this._schemaDesignerService = _schemaDesignerService;
    }
}
exports.SchemaDesignerWebviewController = SchemaDesignerWebviewController;

//# sourceMappingURL=schemaDesignerWebviewController.js.map
