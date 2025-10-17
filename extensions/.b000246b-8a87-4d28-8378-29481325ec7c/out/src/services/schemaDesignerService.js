"use strict";
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SchemaDesignerService = void 0;
const schemaDesigner_1 = require("../models/contracts/schemaDesigner");
class SchemaDesignerService {
    constructor(_sqlToolsClient) {
        this._sqlToolsClient = _sqlToolsClient;
    }
    getSchemaModel(request) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                return yield this._sqlToolsClient.sendRequest(schemaDesigner_1.GetSchemaModelRequest.type, request);
            }
            catch (e) {
                this._sqlToolsClient.logger.error(e);
                throw e;
            }
        });
    }
}
exports.SchemaDesignerService = SchemaDesignerService;

//# sourceMappingURL=schemaDesignerService.js.map
