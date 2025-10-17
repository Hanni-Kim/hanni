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
exports.ConnectionDialogWebviewController = void 0;
const vscode = require("vscode");
const telemetry_1 = require("../sharedInterfaces/telemetry");
const connectionDialog_1 = require("../sharedInterfaces/connectionDialog");
const locConstants_1 = require("../constants/locConstants");
const azureHelpers_1 = require("./azureHelpers");
const telemetry_2 = require("../telemetry/telemetry");
const webview_1 = require("../sharedInterfaces/webview");
const azureController_1 = require("../azure/azureController");
const userSurvey_1 = require("../nps/userSurvey");
const connectionConstants_1 = require("./connectionConstants");
const connectionInfo_1 = require("../models/connectionInfo");
const utils_1 = require("../utils/utils");
const vscode_1 = require("vscode");
const interfaces_1 = require("../models/interfaces");
const formComponentHelpers_1 = require("./formComponentHelpers");
const formWebviewController_1 = require("../forms/formWebviewController");
const connectionCredentials_1 = require("../models/connectionCredentials");
class ConnectionDialogWebviewController extends formWebviewController_1.FormWebviewController {
    //#endregion
    constructor(context, vscodeWrapper, _mainController, _objectExplorerProvider, _connectionToEdit) {
        super(context, vscodeWrapper, "connectionDialog", "connectionDialog", new connectionDialog_1.ConnectionDialogWebviewState(), {
            title: locConstants_1.ConnectionDialog.connectionDialog,
            viewColumn: vscode.ViewColumn.Active,
            iconPath: {
                dark: vscode.Uri.joinPath(context.extensionUri, "media", "connectionDialogEditor_dark.svg"),
                light: vscode.Uri.joinPath(context.extensionUri, "media", "connectionDialogEditor_light.svg"),
            },
        });
        this._mainController = _mainController;
        this._objectExplorerProvider = _objectExplorerProvider;
        this._connectionToEdit = _connectionToEdit;
        this.registerRpcHandlers();
        this.initializeDialog().catch((err) => {
            void vscode.window.showErrorMessage((0, utils_1.getErrorMessage)(err));
            // The spots in initializeDialog() that handle potential PII have their own error catches that emit error telemetry with `includeErrorMessage` set to false.
            // Everything else during initialization shouldn't have PII, so it's okay to include the error message here.
            (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.Initialize, err, true);
        });
    }
    initializeDialog() {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                yield this.updateLoadedConnections(this.state);
                this.updateState();
            }
            catch (err) {
                void vscode.window.showErrorMessage((0, utils_1.getErrorMessage)(err));
                (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.Initialize, err, false);
            }
            try {
                if (this._connectionToEdit) {
                    yield this.loadConnectionToEdit();
                }
                else {
                    yield this.loadEmptyConnection();
                }
            }
            catch (err) {
                yield this.loadEmptyConnection();
                void vscode.window.showErrorMessage((0, utils_1.getErrorMessage)(err));
                (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.Initialize, err, false);
            }
            this.state.formComponents = yield (0, formComponentHelpers_1.generateConnectionComponents)(this._mainController.connectionManager, (0, azureHelpers_1.getAccounts)(this._mainController.azureAccountService), this.getAzureActionButtons());
            this.state.connectionComponents = {
                mainOptions: [...ConnectionDialogWebviewController.mainOptions],
                topAdvancedOptions: [
                    "port",
                    "applicationName",
                    // TODO: 'autoDisconnect',
                    // TODO: 'sslConfiguration',
                    "connectTimeout",
                    "multiSubnetFailover",
                ],
                groupedAdvancedOptions: [], // computed below
            };
            this.state.connectionComponents.groupedAdvancedOptions =
                (0, formComponentHelpers_1.groupAdvancedOptions)(this.state.formComponents, this.state.connectionComponents);
            yield this.updateItemVisibility();
            this.updateState();
        });
    }
    registerRpcHandlers() {
        this.registerReducer("setConnectionInputType", (state, payload) => __awaiter(this, void 0, void 0, function* () {
            this.state.selectedInputMode = payload.inputMode;
            yield this.updateItemVisibility();
            this.updateState();
            if (this.state.selectedInputMode ===
                connectionDialog_1.ConnectionInputMode.AzureBrowse) {
                yield this.loadAllAzureServers(state);
            }
            return state;
        }));
        this.registerReducer("loadConnection", (state, payload) => __awaiter(this, void 0, void 0, function* () {
            (0, telemetry_2.sendActionEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.LoadConnection);
            this._connectionToEditCopy = structuredClone(payload.connection);
            this.clearFormError();
            this.state.connectionProfile = payload.connection;
            this.state.selectedInputMode = this._connectionToEditCopy
                .connectionString
                ? connectionDialog_1.ConnectionInputMode.ConnectionString
                : connectionDialog_1.ConnectionInputMode.Parameters;
            yield this.updateItemVisibility();
            yield this.handleAzureMFAEdits("azureAuthType");
            yield this.handleAzureMFAEdits("accountId");
            return state;
        }));
        this.registerReducer("connect", (state) => __awaiter(this, void 0, void 0, function* () {
            return this.connectHelper(state);
        }));
        this.registerReducer("loadAzureServers", (state, payload) => __awaiter(this, void 0, void 0, function* () {
            yield this.loadAzureServersForSubscription(state, payload.subscriptionId);
            return state;
        }));
        this.registerReducer("addFirewallRule", (state, payload) => __awaiter(this, void 0, void 0, function* () {
            const [startIp, endIp] = typeof payload.ip === "string"
                ? [payload.ip, payload.ip]
                : [payload.ip.startIp, payload.ip.endIp];
            console.debug(`Setting firewall rule: "${payload.name}" (${startIp} - ${endIp})`);
            let account, tokenMappings;
            try {
                ({ account, tokenMappings } =
                    yield this.constructAzureAccountForTenant(payload.tenantId));
            }
            catch (err) {
                state.formError = locConstants_1.ConnectionDialog.errorCreatingFirewallRule(`"${payload.name}" (${startIp} - ${endIp})`, (0, utils_1.getErrorMessage)(err));
                state.dialog = undefined;
                (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.AddFirewallRule, err, false, // includeErrorMessage
                undefined, // errorCode
                undefined, // errorType
                {
                    failure: "constructAzureAccountForTenant",
                });
                return state;
            }
            const result = yield this._mainController.connectionManager.firewallService.createFirewallRule({
                account: account,
                firewallRuleName: payload.name,
                startIpAddress: startIp,
                endIpAddress: endIp,
                serverName: this.state.connectionProfile.server,
                securityTokenMappings: tokenMappings,
            });
            if (!result.result) {
                state.formError = locConstants_1.ConnectionDialog.errorCreatingFirewallRule(`"${payload.name}" (${startIp} - ${endIp})`, result.errorMessage);
                (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.AddFirewallRule, new Error(result.errorMessage), false, // includeErrorMessage
                undefined, // errorCode
                undefined, // errorType
                {
                    failure: "firewallService.createFirewallRule",
                });
            }
            (0, telemetry_2.sendActionEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.AddFirewallRule);
            state.dialog = undefined;
            this.updateState(state);
            return yield this.connectHelper(state);
        }));
        this.registerReducer("closeDialog", (state) => __awaiter(this, void 0, void 0, function* () {
            state.dialog = undefined;
            return state;
        }));
        this.registerReducer("filterAzureSubscriptions", (state) => __awaiter(this, void 0, void 0, function* () {
            yield (0, azureHelpers_1.promptForAzureSubscriptionFilter)(state);
            yield this.loadAllAzureServers(state);
            return state;
        }));
        this.registerReducer("refreshConnectionsList", (state) => __awaiter(this, void 0, void 0, function* () {
            yield this.updateLoadedConnections(state);
            return state;
        }));
        this.registerReducer("deleteSavedConnection", (state, payload) => __awaiter(this, void 0, void 0, function* () {
            const confirm = yield vscode.window.showQuickPick([locConstants_1.Common.delete, locConstants_1.Common.cancel], {
                title: locConstants_1.Common.areYouSureYouWantTo(locConstants_1.ConnectionDialog.deleteTheSavedConnection(payload.connection.displayName)),
            });
            if (confirm !== locConstants_1.Common.delete) {
                return state;
            }
            const success = yield this._mainController.connectionManager.connectionStore.removeProfile(payload.connection);
            if (success) {
                yield this.updateLoadedConnections(state);
            }
            return state;
        }));
        this.registerReducer("removeRecentConnection", (state, payload) => __awaiter(this, void 0, void 0, function* () {
            yield this._mainController.connectionManager.connectionStore.removeRecentlyUsed(payload.connection);
            yield this.updateLoadedConnections(state);
            return state;
        }));
    }
    //#region Helpers
    //#region Connection helpers
    afterSetFormProperty(propertyName) {
        return __awaiter(this, void 0, void 0, function* () {
            return yield this.handleAzureMFAEdits(propertyName);
        });
    }
    updateItemVisibility() {
        return __awaiter(this, void 0, void 0, function* () {
            let hiddenProperties = [];
            if (this.state.selectedInputMode === connectionDialog_1.ConnectionInputMode.Parameters ||
                this.state.selectedInputMode === connectionDialog_1.ConnectionInputMode.AzureBrowse) {
                if (this.state.connectionProfile.authenticationType !==
                    connectionDialog_1.AuthenticationType.SqlLogin) {
                    hiddenProperties.push("user", "password", "savePassword");
                }
                if (this.state.connectionProfile.authenticationType !==
                    connectionDialog_1.AuthenticationType.AzureMFA) {
                    hiddenProperties.push("accountId", "tenantId");
                }
                if (this.state.connectionProfile.authenticationType ===
                    connectionDialog_1.AuthenticationType.AzureMFA) {
                    // Hide tenantId if accountId has only one tenant
                    const tenants = yield (0, azureHelpers_1.getTenants)(this._mainController.azureAccountService, this.state.connectionProfile.accountId);
                    if (tenants.length === 1) {
                        hiddenProperties.push("tenantId");
                    }
                }
            }
            for (const component of Object.values(this.state.formComponents)) {
                component.hidden = hiddenProperties.includes(component.propertyName);
            }
        });
    }
    getActiveFormComponents(state) {
        if (state.selectedInputMode === connectionDialog_1.ConnectionInputMode.Parameters ||
            state.selectedInputMode === connectionDialog_1.ConnectionInputMode.AzureBrowse) {
            return state.connectionComponents.mainOptions;
        }
        return ["connectionString", "profileName"];
    }
    /** Returns a copy of `connection` that's been cleaned up by clearing the properties that aren't being used
     * (e.g. due to form selections, like authType and inputMode) */
    cleanConnection(connection) {
        const cleanedConnection = structuredClone(connection);
        // Clear values for inputs that are hidden due to form selections
        for (const option of Object.values(this.state.formComponents)) {
            if (option.hidden) {
                cleanedConnection[option.propertyName
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                ] = undefined;
            }
        }
        // Clear values for inputs that are not applicable due to the selected input mode
        if (this.state.selectedInputMode === connectionDialog_1.ConnectionInputMode.Parameters ||
            this.state.selectedInputMode === connectionDialog_1.ConnectionInputMode.AzureBrowse) {
            cleanedConnection.connectionString = undefined;
        }
        else if (this.state.selectedInputMode ===
            connectionDialog_1.ConnectionInputMode.ConnectionString) {
            Object.keys(cleanedConnection).forEach((key) => {
                if (key !== "connectionString" && key !== "profileName") {
                    cleanedConnection[key] = undefined;
                }
            });
        }
        return cleanedConnection;
    }
    loadConnections() {
        return __awaiter(this, void 0, void 0, function* () {
            const unsortedConnections = yield this._mainController.connectionManager.connectionStore.readAllConnections(true /* includeRecentConnections */);
            const savedConnections = unsortedConnections.filter((c) => c.profileSource === interfaces_1.CredentialsQuickPickItemType.Profile);
            const recentConnections = unsortedConnections.filter((c) => c.profileSource === interfaces_1.CredentialsQuickPickItemType.Mru);
            (0, telemetry_2.sendActionEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.LoadRecentConnections, undefined, // additionalProperties
            {
                savedConnectionsCount: savedConnections.length,
                recentConnectionsCount: recentConnections.length,
            });
            return {
                recentConnections: yield Promise.all(recentConnections
                    .map((conn) => {
                    try {
                        return this.initializeConnectionForDialog(conn);
                    }
                    catch (ex) {
                        console.error("Error initializing recent connection: " +
                            (0, utils_1.getErrorMessage)(ex));
                        (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.LoadConnections, ex, false, // includeErrorMessage
                        undefined, // errorCode
                        undefined, // errorType
                        {
                            connectionType: "recent",
                            authType: conn.authenticationType,
                        });
                        return Promise.resolve(undefined);
                    }
                })
                    .filter((c) => c !== undefined)),
                savedConnections: yield Promise.all(savedConnections
                    .map((conn) => {
                    try {
                        return this.initializeConnectionForDialog(conn);
                    }
                    catch (ex) {
                        console.error("Error initializing saved connection: " +
                            (0, utils_1.getErrorMessage)(ex));
                        (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.LoadConnections, ex, false, // includeErrorMessage
                        undefined, // errorCode
                        undefined, // errorType
                        {
                            connectionType: "saved",
                            authType: conn.authenticationType,
                        });
                        return Promise.resolve(undefined);
                    }
                })
                    .filter((c) => c !== undefined)),
            };
        });
    }
    updateLoadedConnections(state) {
        return __awaiter(this, void 0, void 0, function* () {
            const loadedConnections = yield this.loadConnections();
            state.recentConnections = loadedConnections.recentConnections;
            state.savedConnections = loadedConnections.savedConnections;
        });
    }
    validateProfile(connectionProfile) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!connectionProfile) {
                connectionProfile = this.state.connectionProfile;
            }
            // clean the connection by clearing the options that aren't being used
            const cleanedConnection = this.cleanConnection(connectionProfile);
            return yield this.validateForm(cleanedConnection);
        });
    }
    connectHelper(state) {
        return __awaiter(this, void 0, void 0, function* () {
            this.clearFormError();
            this.state.connectionStatus = webview_1.ApiStatus.Loading;
            this.updateState();
            let cleanedConnection = this.cleanConnection(this.state.connectionProfile);
            const erroredInputs = yield this.validateProfile(cleanedConnection);
            if (erroredInputs.length > 0) {
                this.state.connectionStatus = webview_1.ApiStatus.Error;
                console.warn("One more more inputs have errors: " + erroredInputs.join(", "));
                return state;
            }
            try {
                try {
                    if (this.state.selectedInputMode ===
                        connectionDialog_1.ConnectionInputMode.ConnectionString) {
                        // convert connection string to an IConnectionProfile object
                        const connDetails = yield this._mainController.connectionManager.buildConnectionDetails(this.state.connectionProfile.connectionString);
                        cleanedConnection =
                            connectionCredentials_1.ConnectionCredentials.createConnectionInfo(connDetails);
                        // re-add profileName and savePassword because they aren't part of the connection string
                        cleanedConnection.profileName =
                            this.state.connectionProfile.profileName;
                        cleanedConnection.savePassword =
                            !!cleanedConnection.password; // if the password is included in the connection string, saving it is implied
                        // overwrite SQL Tools Service's default application name with the one the user provided (or MSSQL's default)
                        cleanedConnection.applicationName =
                            this.state.connectionProfile.applicationName;
                    }
                    const result = yield this._mainController.connectionManager.connectDialog(
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    cleanedConnection);
                    if (result.errorMessage) {
                        return yield this.handleConnectionErrorCodes(result, state);
                    }
                }
                catch (error) {
                    this.state.formError = (0, utils_1.getErrorMessage)(error);
                    this.state.connectionStatus = webview_1.ApiStatus.Error;
                    (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.CreateConnection, error, false, // includeErrorMessage
                    undefined, // errorCode
                    undefined, // errorType
                    {
                        connectionInputType: this.state.selectedInputMode,
                        authMode: this.state.connectionProfile.authenticationType,
                    });
                    return state;
                }
                (0, telemetry_2.sendActionEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.CreateConnection, {
                    result: "success",
                    newOrEditedConnection: this._connectionToEditCopy
                        ? "edited"
                        : "new",
                    connectionInputType: this.state.selectedInputMode,
                    authMode: this.state.connectionProfile.authenticationType,
                });
                if (this._connectionToEditCopy) {
                    this._mainController.connectionManager.getUriForConnection(this._connectionToEditCopy);
                    yield this._objectExplorerProvider.removeConnectionNodes([
                        this._connectionToEditCopy,
                    ]);
                    yield this._mainController.connectionManager.connectionStore.removeProfile(
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    this._connectionToEditCopy);
                    this._objectExplorerProvider.refresh(undefined);
                }
                // all properties are set when converting from a ConnectionDetails object,
                // so we want to clean the default undefined properties before saving.
                cleanedConnection = this.removeUndefinedProperties(
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                cleanedConnection);
                yield this._mainController.connectionManager.connectionStore.saveProfile(
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                cleanedConnection);
                const node = yield this._mainController.createObjectExplorerSessionFromDialog(cleanedConnection);
                this._objectExplorerProvider.refresh(undefined);
                yield this.updateLoadedConnections(state);
                this.updateState();
                this.state.connectionStatus = webview_1.ApiStatus.Loaded;
                yield this._mainController.objectExplorerTree.reveal(node, {
                    focus: true,
                    select: true,
                    expand: true,
                });
                yield this.panel.dispose();
                userSurvey_1.UserSurvey.getInstance().promptUserForNPSFeedback();
            }
            catch (error) {
                this.state.connectionStatus = webview_1.ApiStatus.Error;
                (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.CreateConnection, error, undefined, // includeErrorMessage
                undefined, // errorCode
                undefined, // errorType
                {
                    connectionInputType: this.state.selectedInputMode,
                    authMode: this.state.connectionProfile.authenticationType,
                });
                return state;
            }
            return state;
        });
    }
    removeUndefinedProperties(connProfile) {
        // TODO: ideally this compares against the default values acquired from a source of truth (e.g. STS),
        // so that it can clean up more than just undefined properties.
        const output = Object.assign({}, connProfile);
        for (const key of Object.keys(output)) {
            if (output[key] === undefined ||
                // eslint-disable-next-line no-restricted-syntax
                output[key] === null) {
                delete output[key];
            }
        }
        return output;
    }
    handleConnectionErrorCodes(result, state) {
        return __awaiter(this, void 0, void 0, function* () {
            if (result.errorNumber === connectionConstants_1.connectionCertValidationFailedErrorCode) {
                this.state.connectionStatus = webview_1.ApiStatus.Error;
                this.state.dialog = {
                    type: "trustServerCert",
                    message: result.errorMessage,
                };
                // connection failing because the user didn't trust the server cert is not an error worth logging;
                // just prompt the user to trust the cert
                return state;
            }
            else if (result.errorNumber === connectionConstants_1.connectionFirewallErrorCode) {
                this.state.connectionStatus = webview_1.ApiStatus.Error;
                const handleFirewallErrorResult = yield this._mainController.connectionManager.firewallService.handleFirewallRule(result.errorNumber, result.errorMessage);
                if (!handleFirewallErrorResult.result) {
                    (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.AddFirewallRule, new Error(result.errorMessage), true, // includeErrorMessage; parse failed because it couldn't detect an IP address, so that'd be the only PII
                    undefined, // errorCode
                    undefined);
                    // Proceed with 0.0.0.0 as the client IP, and let user fill it out manually.
                    handleFirewallErrorResult.ipAddress = "0.0.0.0";
                }
                const auth = yield (0, azureHelpers_1.confirmVscodeAzureSignin)();
                const tenants = yield auth.getTenants();
                this.state.dialog = {
                    type: "addFirewallRule",
                    message: result.errorMessage,
                    clientIp: handleFirewallErrorResult.ipAddress,
                    tenants: tenants.map((t) => {
                        return {
                            name: t.displayName,
                            id: t.tenantId,
                        };
                    }),
                };
                return state;
            }
            this.state.formError = result.errorMessage;
            this.state.connectionStatus = webview_1.ApiStatus.Error;
            (0, telemetry_2.sendActionEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.CreateConnection, {
                result: "connectionError",
                errorNumber: String(result.errorNumber),
                newOrEditedConnection: this._connectionToEditCopy
                    ? "edited"
                    : "new",
                connectionInputType: this.state.selectedInputMode,
                authMode: this.state.connectionProfile.authenticationType,
            });
            return state;
        });
    }
    loadConnectionToEdit() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this._connectionToEdit) {
                this._connectionToEditCopy = structuredClone(this._connectionToEdit);
                const connection = yield this.initializeConnectionForDialog(this._connectionToEdit);
                this.state.connectionProfile = connection;
                this.state.selectedInputMode =
                    connection.connectionString && connection.server === undefined
                        ? connectionDialog_1.ConnectionInputMode.ConnectionString
                        : connectionDialog_1.ConnectionInputMode.Parameters;
                this.updateState();
            }
        });
    }
    loadEmptyConnection() {
        return __awaiter(this, void 0, void 0, function* () {
            const emptyConnection = {
                authenticationType: connectionDialog_1.AuthenticationType.SqlLogin,
                connectTimeout: 30, // seconds
                applicationName: "vscode-mssql",
            };
            this.state.connectionProfile = emptyConnection;
        });
    }
    initializeConnectionForDialog(connection) {
        return __awaiter(this, void 0, void 0, function* () {
            // Load the password if it's saved
            const isConnectionStringConnection = connection.connectionString !== undefined &&
                connection.connectionString !== "";
            if (!isConnectionStringConnection) {
                const password = yield this._mainController.connectionManager.connectionStore.lookupPassword(connection, isConnectionStringConnection);
                connection.password = password;
            }
            else {
                // If the connection is a connection string connection with SQL Auth:
                //   * the full connection string is stored as the "password" in the credential store
                //   * we need to extract the password from the connection string
                // If the connection is a connection string connection with a different auth type, then there's nothing in the credential store.
                const connectionString = yield this._mainController.connectionManager.connectionStore.lookupPassword(connection, isConnectionStringConnection);
                if (connectionString) {
                    const passwordIndex = connectionString
                        .toLowerCase()
                        .indexOf("password=");
                    if (passwordIndex !== -1) {
                        // extract password from connection string; found between 'Password=' and the next ';'
                        const passwordStart = passwordIndex + "password=".length;
                        const passwordEnd = connectionString.indexOf(";", passwordStart);
                        if (passwordEnd !== -1) {
                            connection.password = connectionString.substring(passwordStart, passwordEnd);
                        }
                        // clear the connection string from the IConnectionDialogProfile so that the ugly connection string key
                        // that's used to look up the actual connection string (with password) isn't displayed
                        connection.connectionString = "";
                    }
                }
            }
            const dialogConnection = connection;
            // Set the display name
            dialogConnection.displayName = dialogConnection.profileName
                ? dialogConnection.profileName
                : (0, connectionInfo_1.getConnectionDisplayName)(connection);
            return dialogConnection;
        });
    }
    //#endregion
    //#region Azure helpers
    getAzureActionButtons() {
        return __awaiter(this, void 0, void 0, function* () {
            const actionButtons = [];
            actionButtons.push({
                label: locConstants_1.ConnectionDialog.signIn,
                id: "azureSignIn",
                callback: () => __awaiter(this, void 0, void 0, function* () {
                    const account = yield this._mainController.azureAccountService.addAccount();
                    const accountsComponent = this.getFormComponent(this.state, "accountId");
                    if (accountsComponent) {
                        accountsComponent.options = yield (0, azureHelpers_1.getAccounts)(this._mainController.azureAccountService);
                        this.state.connectionProfile.accountId = account.key.id;
                        this.updateState();
                        yield this.handleAzureMFAEdits("accountId");
                    }
                }),
            });
            if (this.state.connectionProfile.authenticationType ===
                connectionDialog_1.AuthenticationType.AzureMFA &&
                this.state.connectionProfile.accountId) {
                const account = (yield this._mainController.azureAccountService.getAccounts()).find((account) => account.displayInfo.userId ===
                    this.state.connectionProfile.accountId);
                if (account) {
                    const session = yield this._mainController.azureAccountService.getAccountSecurityToken(account, undefined);
                    const isTokenExpired = !azureController_1.AzureController.isTokenValid(session.token, session.expiresOn);
                    if (isTokenExpired) {
                        actionButtons.push({
                            label: locConstants_1.refreshTokenLabel,
                            id: "refreshToken",
                            callback: () => __awaiter(this, void 0, void 0, function* () {
                                const account = (yield this._mainController.azureAccountService.getAccounts()).find((account) => account.displayInfo.userId ===
                                    this.state.connectionProfile.accountId);
                                if (account) {
                                    const session = yield this._mainController.azureAccountService.getAccountSecurityToken(account, undefined);
                                    this.logger.log("Token refreshed", session.expiresOn);
                                }
                            }),
                        });
                    }
                }
            }
            return actionButtons;
        });
    }
    handleAzureMFAEdits(propertyName) {
        return __awaiter(this, void 0, void 0, function* () {
            const mfaComponents = [
                "accountId",
                "tenantId",
                "authenticationType",
            ];
            if (mfaComponents.includes(propertyName)) {
                if (this.state.connectionProfile.authenticationType !==
                    connectionDialog_1.AuthenticationType.AzureMFA) {
                    return;
                }
                const accountComponent = this.getFormComponent(this.state, "accountId");
                const tenantComponent = this.getFormComponent(this.state, "tenantId");
                let tenants = [];
                switch (propertyName) {
                    case "accountId":
                        tenants = yield (0, azureHelpers_1.getTenants)(this._mainController.azureAccountService, this.state.connectionProfile.accountId);
                        if (tenantComponent) {
                            tenantComponent.options = tenants;
                            if (tenants && tenants.length > 0) {
                                this.state.connectionProfile.tenantId =
                                    tenants[0].value;
                            }
                        }
                        accountComponent.actionButtons =
                            yield this.getAzureActionButtons();
                        break;
                    case "tenantId":
                        break;
                    case "authenticationType":
                        const firstOption = accountComponent.options[0];
                        if (firstOption) {
                            this.state.connectionProfile.accountId =
                                firstOption.value;
                        }
                        tenants = yield (0, azureHelpers_1.getTenants)(this._mainController.azureAccountService, this.state.connectionProfile.accountId);
                        if (tenantComponent) {
                            tenantComponent.options = tenants;
                            if (tenants && tenants.length > 0) {
                                this.state.connectionProfile.tenantId =
                                    tenants[0].value;
                            }
                        }
                        accountComponent.actionButtons =
                            yield this.getAzureActionButtons();
                        break;
                }
            }
        });
    }
    constructAzureAccountForTenant(tenantId) {
        return __awaiter(this, void 0, void 0, function* () {
            const auth = yield (0, azureHelpers_1.confirmVscodeAzureSignin)();
            const subs = yield auth.getSubscriptions(false /* filter */);
            const sub = subs.filter((s) => s.tenantId === tenantId)[0];
            if (!sub) {
                throw new Error(locConstants_1.ConnectionDialog.errorLoadingAzureAccountInfoForTenantId(tenantId));
            }
            const token = yield sub.credential.getToken(".default");
            const session = yield sub.authentication.getSession();
            const account = {
                displayInfo: {
                    displayName: session.account.label,
                    userId: session.account.label,
                    name: session.account.label,
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    accountType: session.account.type,
                },
                key: {
                    providerId: "microsoft",
                    id: session.account.label,
                },
                isStale: false,
                properties: {
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    azureAuthType: 0,
                    providerSettings: undefined,
                    isMsAccount: false,
                    owningTenant: undefined,
                    tenants: [
                        {
                            displayName: sub.tenantId,
                            id: sub.tenantId,
                            userId: token.token,
                        },
                    ],
                },
            };
            const tokenMappings = {};
            tokenMappings[sub.tenantId] = {
                Token: token.token,
            };
            return { account, tokenMappings };
        });
    }
    loadAzureSubscriptions(state) {
        return __awaiter(this, void 0, void 0, function* () {
            let endActivity;
            try {
                const auth = yield (0, azureHelpers_1.confirmVscodeAzureSignin)();
                if (!auth) {
                    state.formError = vscode_1.l10n.t("Azure sign in failed.");
                    return undefined;
                }
                state.loadingAzureSubscriptionsStatus = webview_1.ApiStatus.Loading;
                this.updateState();
                // getSubscriptions() below checks this config setting if filtering is specified.  If the user has this set, then we use it; if not, we get all subscriptions.
                // The specific vscode config setting it uses is hardcoded into the VS Code Azure SDK, so we need to use the same value here.
                const shouldUseFilter = vscode.workspace
                    .getConfiguration()
                    .get(azureHelpers_1.azureSubscriptionFilterConfigKey) !== undefined;
                endActivity = (0, telemetry_2.startActivity)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.LoadAzureSubscriptions);
                this._azureSubscriptions = new Map((yield auth.getSubscriptions(shouldUseFilter)).map((s) => [
                    s.subscriptionId,
                    s,
                ]));
                const tenantSubMap = this.groupBy(Array.from(this._azureSubscriptions.values()), "tenantId"); // TODO: replace with Object.groupBy once ES2024 is supported
                const subs = [];
                for (const t of tenantSubMap.keys()) {
                    for (const s of tenantSubMap.get(t)) {
                        subs.push({
                            id: s.subscriptionId,
                            name: s.name,
                            loaded: false,
                        });
                    }
                }
                state.azureSubscriptions = subs;
                state.loadingAzureSubscriptionsStatus = webview_1.ApiStatus.Loaded;
                endActivity.end(telemetry_1.ActivityStatus.Succeeded, undefined, // additionalProperties
                {
                    subscriptionCount: subs.length,
                });
                this.updateState();
                return tenantSubMap;
            }
            catch (error) {
                state.formError = vscode_1.l10n.t("Error loading Azure subscriptions.");
                state.loadingAzureSubscriptionsStatus = webview_1.ApiStatus.Error;
                console.error(state.formError + "\n" + (0, utils_1.getErrorMessage)(error));
                endActivity.endFailed(error, false);
                return undefined;
            }
        });
    }
    loadAllAzureServers(state) {
        return __awaiter(this, void 0, void 0, function* () {
            const endActivity = (0, telemetry_2.startActivity)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.LoadAzureServers);
            try {
                const tenantSubMap = yield this.loadAzureSubscriptions(state);
                if (!tenantSubMap) {
                    return;
                }
                if (tenantSubMap.size === 0) {
                    state.formError = vscode_1.l10n.t("No subscriptions available.  Adjust your subscription filters to try again.");
                }
                else {
                    state.loadingAzureServersStatus = webview_1.ApiStatus.Loading;
                    state.azureServers = [];
                    this.updateState();
                    const promiseArray = [];
                    for (const t of tenantSubMap.keys()) {
                        for (const s of tenantSubMap.get(t)) {
                            promiseArray.push(this.loadAzureServersForSubscription(state, s.subscriptionId));
                        }
                    }
                    yield Promise.all(promiseArray);
                    endActivity.end(telemetry_1.ActivityStatus.Succeeded, undefined, // additionalProperties
                    {
                        subscriptionCount: promiseArray.length,
                    });
                    state.loadingAzureServersStatus = webview_1.ApiStatus.Loaded;
                    return;
                }
            }
            catch (error) {
                state.formError = vscode_1.l10n.t("Error loading Azure databases.");
                state.loadingAzureServersStatus = webview_1.ApiStatus.Error;
                console.error(state.formError + "\n" + (0, utils_1.getErrorMessage)(error));
                endActivity.endFailed(error, false);
                return;
            }
        });
    }
    loadAzureServersForSubscription(state, subscriptionId) {
        return __awaiter(this, void 0, void 0, function* () {
            const azSub = this._azureSubscriptions.get(subscriptionId);
            const stateSub = state.azureSubscriptions.find((s) => s.id === subscriptionId);
            try {
                const servers = yield (0, azureHelpers_1.fetchServersFromAzure)(azSub);
                state.azureServers.push(...servers);
                stateSub.loaded = true;
                this.updateState();
                console.log(`Loaded ${servers.length} servers for subscription ${azSub.name} (${azSub.subscriptionId})`);
            }
            catch (error) {
                console.error(locConstants_1.ConnectionDialog.errorLoadingAzureDatabases(azSub.name, azSub.subscriptionId), +"\n" + (0, utils_1.getErrorMessage)(error));
                (0, telemetry_2.sendErrorEvent)(telemetry_1.TelemetryViews.ConnectionDialog, telemetry_1.TelemetryActions.LoadAzureServers, error, true, // includeErrorMessage
                undefined, // errorCode
                undefined);
            }
        });
    }
    //#endregion
    //#region Miscellanous helpers
    clearFormError() {
        this.state.formError = "";
        for (const component of this.getActiveFormComponents(this.state).map((x) => this.state.formComponents[x])) {
            component.validation = undefined;
        }
    }
    groupBy(values, key) {
        return values.reduce((rv, x) => {
            const keyValue = x[key];
            if (!rv.has(keyValue)) {
                rv.set(keyValue, []);
            }
            rv.get(keyValue).push(x);
            return rv;
        }, new Map());
    }
}
exports.ConnectionDialogWebviewController = ConnectionDialogWebviewController;
//#region Properties
ConnectionDialogWebviewController.mainOptions = [
    "server",
    "trustServerCertificate",
    "authenticationType",
    "user",
    "password",
    "savePassword",
    "accountId",
    "tenantId",
    "database",
    "encrypt",
];

//# sourceMappingURL=connectionDialogWebviewController.js.map
