"GSCCP" "custom procedure" "gsc_custom_procedure" yes "" 41 "procedure_name" "" "Due to the complexity and variety of certain business processes, such as calculating contribution amounts, determining limits, etc. parameterisation of these processes becomes impractical.
This table contains a list of all the system supported procedures that satisfy these business rules, categorised by entity and procedure type. A number of variations for each process may exist - the procedure to use in each case must be selected from this list.

The programs that these procedures exist in will run persistently when required." "custom_procedure_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCDC" "default code" "gsc_default_code" yes "" 1004947239.09 "field_name" "" "This table makes provision for any number of parameters or system defaults that need be specified to the system, without neccessitating structural database changes.

How these parameters / defaults are used needs to be hard coded into the application.

These records can be grouped into sets under gsc_default_set, to facilitate different parameter / defaults sets. Again, the selection of a default set would be coded into the application.

An example would be different parameter sets for warehouse control, different controls per administration group etc." "default_code_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCDD" "deploy dataset" "gsc_deploy_dataset" yes "" 1004927719.09 "dataset_description" "" "This table defines the sets of data that need to be deployed to end-user sites and migrated to different workspace databases. Usually it is static data that needs to be deployed. This table with its child table gsc_dataset_entity identify which data must be deployed as a set, i.e. has dependancies. For example, in order to deploy menu items, objects on the menu item would also need to be deployed.

These tables also define the dataset for deployment of logical objects managed by the scm tool, e.g. the ryc_smartobject and related tables.

To deploy and load the data, xml files will be generated for the dataset.

The dataset must always have a main table that is being deployed, plus all related tables that need to be deployed with it, together with appropriate join information.

Example datasets could be for SmartObjects, menus, objects, etc. It is likely that a seperate dataset will be defined for most data tables that need to be deployed, but that these datasets will include a parent dataset that includes this dataset.

When automatically generating triggers from ERWin an entity-level UDP (DeployData) is used to indicate whether trigger code should be generated for the static tables to support data deployment. A flag also exists in the entity mnemonic table called deploy_data for the same purpose.

For customer sites that receive a dataset deployment, the last deployment loaded for this dataset is record here. This helps identify at what version the current static data is for a particular database.

Customers should not modify or deploy from datasets sent by suppliers. The customer can however create their own datasets containing the same tables and deploy from these datasets. As a dataset deployment includes an xml file registered as part of the deployment, the customer can simply utilise this xml file for their database and any subsequent databases and sites they wish to pass the data on to." "deploy_dataset_obj" yes "dataset_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCDE" "dataset entity" "gsc_dataset_entity" yes "" 1004927718.09 "" "" "This table contains a complete list of tables that need to be deployed with the  dataset.

One of the tables in the dataset must be marked as primary, i.e. the main table in the dataset. The join information between the tables must also be specified.

The data in this table can be filtered using the filter where clause." "dataset_entity_obj" yes "dataset_entity_obj" 4 "_" no yes yes "icfdb" "" "" ""
"GSCDM" "delivery method" "gsc_delivery_method" yes "" 1004924364.09 "delivery_method_description" "" "The supported methods of delivery, e.g. by hand, post, email, collection, etc." "delivery_method_obj" yes "delivery_method_tla" 4 "_" no yes yes "icfdb" "" "" ""
"GSCDP" "deploy package" "gsc_deploy_package" yes "" 4618.24 "package_description" "" "This table facilitates defining groups of datasets that should be deployed together as a single package. This enables users to ensure they send all related datasets inclduing related / dependant data that has also changed." "deploy_package_obj" yes "package_code" 4 "_" no yes yes "ICFDB" "" "" ""
"GSCDS" "default set" "gsc_default_set" yes "" 1004924362.09 "default_set_description" "" "This table is used to associate a set of parameters / defaults i.e. a set of gsc_default_code records.

For example, there could be a general set of defaults applicable to the system in general, and other sets of defaults to be used in certain circumstances e.g. for a specific department.

The way these sets are used must be hard coded into the application." "default_set_obj" yes "default_set_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCDT" "document type" "gsc_document_type" yes "" 1004924365.09 "document_type_description" "" "The document types supported by the system. Certain document types will be hard coded as they form an integral part of the application, e.g. membership cards, etc.

Each document type will have one or more document formats associated with a customised formatting procedure.

A document type should be set up for any outgoing documents.

We need to know the document_type_tla for system owned document types as this will be used in any print_option_tlas fields to determine where certain data should be printed.

" "document_type_obj" yes "document_type_tla" 4 "_" no yes yes "icfdb" "" "" ""
"GSCDU" "default set usage" "gsc_default_set_usage" yes "" 1004924363.09 "" "" "This table associates default sets with objects in the application.

For example, in property administration, a default set could be for a specific administration company. In medical aid, a default set could be for a specific scheme option, employer group etc." "default_set_usage_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCED" "entity display field" "gsc_entity_display_field" yes "" 1005079469.09 "display_field_name" "" "This table defines the fields for a table that should be used when building generic objects for it, e.g. a dynamic browser.

It identifies the fields that should be used, the sequence of the fields, plus allows the label and format of the fields to be overridden.

This is actually used in the generic data security used by the framework. 

If no entries exist in this table, then all the fields other than any object fields will be used, in the standard field order as defined in the database.

This table should initially be populated automatically from the metaschema but may then be modified accordingly.

This table does not support joined fields.
" "entity_display_field_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCEM" "entity mnemonic" "gsc_entity_mnemonic" yes "" 1004924406.09 "entity_mnemonic_description" "" "This table stores all the hard coded entity mnemonics allocated to every table in the application. It defines a meaningful short code and identifies the table name for each table.

It also defines generic information about the entity used when generating dynamic or generic objects based on the table, auto generating triggers, etc." "entity_mnemonic_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCEP" "entity mnemonic procedure" "gsc_entity_mnemonic_procedure" yes "" 1004924366.09 "" "" "This table contains pointers to procedures which may be automatically run by the system before and after table create, write and delete triggers.

The procedures would exist under a single category type with 6 category groups:
Before create
After create
Before write
After write
Before delete
After delete." "entity_mnemonic_procedure_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCER" "error" "gsc_error" yes "" 1004924407.09 "error_summary_description" "" "This table defines all the application errors that can occur, together with summary and full descriptions.

The summary description will be shown first, with an option to display a fuller description if available.

The use of error codes from this table facilitates the customisation of error messages.

This table now supports any kind of message to the user. No messages should be hard coded in the application at all, every message to the user should be channelled through here. Supported message types are:

MES = Message
INF = Information
ERR = Error
WAR = Warning
QUE = Question

The default is ERR for Error if nothing is set-up.

Errors in multiple langages are also supported if required.
" "error_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCGC" "global control" "gsc_global_control" yes "" 1004924367.09 "" "" "This table defines system wide defaults. It contains a single record within which to hold the current system defaults.
" "global_control_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCGD" "global default" "gsc_global_default" yes "" 1004924368.09 "" "" "This table contains global default values across the entire application. It differes from the parameter file in that the parameter file is specific to a user, whereas entries in this table are system wide.

Standard entries exist in the gsc_global_control table. This table facilitates the generic addition of other defaults without the need for database change. The entries in this table will be system owned by ther nature, and the only fields that may change are the owning_obj and the default_value. The changing of any of these values will create a new record for the owning_entity_mnemonic and default_type, efffective as of the new date with the new values.

Entries may not therefore be deleted from this table, other than by a system administrator." "global_default_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCIA" "instance attribute" "gsc_instance_attribute" yes "" 1004924408.09 "attribute_description" "" "This table contains instance attributes used in the application. Instance attributes change the behaviour of generic objects. For example, a generic object could be developed that behaved differently in a creditors and debtors system. An instance attribute of creditor or debtor could be posted to the program when run to determine its instance specific functionality.

The instance attribute will be posted to the program either via the menu option the program was run from, as setup in the menu option, or hard coded in a program if the program was run from a button, etc.

For this reason, certain instance attributes will be system owned and cannot be maintained / deleted by users.

When security structures e.g. field security are setup, they may be defined globally, for a specific product, product module or down to individual program level. The instance attribute is a level below the program level that permits security settings per instance of a program.

Instance attributes will also be used for reporting to allow reports to be printed direct from menu options. The instance attribute code must map to the report_procedure_name in the report_definition table. Whenever a report definition is created, an instance attribute should automatically be created to facilitate this functionality.

" "instance_attribute_obj" yes "attribute_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCIC" "item category" "gsc_item_category" yes "" 1007600146.08 "item_category_description" "" "This table is used to categorize items into common groups. Typical groups may be ADM Navigation, ADM TableIO or  ADM Menu . Categories may also be used to group items into module specific areas." "item_category_obj" yes "item_category_obj" 4 "_" no yes yes "ICFDB" "" "" ""
"GSCLG" "language" "gsc_language" yes "" 1004924369.09 "language_name" "" "The languages supported by the system." "language_obj" yes "language_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCLS" "logical service" "gsc_logical_service" yes "" 1004924409.09 "logical_service_description" "" "This table defines the logical services available to the application.

A logical service is a separate process running either locally or remotely that requires connection parameters to establish communication between the client and the service. 

Logical service names are unique so that connection to the service can be completely abstracted from the developer. 

The physical service will determine the actual connection parameters.

Which physical service is used is determined by combining the session type with the logical service.

Logical services for appserver service types would in fact be appserver partition names. Logical services for database connection service types would be the logical database name.
" "logical_service_obj" yes "logical_service_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCLT" "language text" "gsc_language_text" yes "" 54 "" "" "Totally generic text file for all supported languages. Text's may be associated with another entity (via owning_obj) or may be simply generic text of a certain type. Numbers enclosed in {} are for parameter substitution.
E.g. Scheme option names, transaction narrations, valid people titles, etc." "language_text_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCMM" "multi media type" "gsc_multi_media_type" yes "" 1004924370.09 "multi_media_type_description" "" "This table contains information related to different types of multi media files." "multi_media_type_obj" yes "multi_media_type_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCMT" "manager type" "gsc_manager_type" yes "" 1004924410.09 "manager_type_name" "" "This table contains the definition of the standard managers that are used in the framework.

A predefined set of managers will exist in this table that support the framework functionality. Only managers that directly affect the core functionality of the framework need to be defined as manager types.

For example, without a session manager we cannot start any other code, without a security manager we cannot do user authentication, etc.

" "manager_type_obj" yes "manager_type_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCNA" "nationality" "gsc_nationality" yes "" 1004924371.09 "nationality_name" "" "" "nationality_obj" yes "nationality_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCOB" "object" "gsc_object" yes "" 1004924412.09 "object_description" "" "This table defines the objects (programs) that exist within your applications. Not every program needs to be added as an object - only programs that require security, or that need to appear on a dynamic menu need be setup.

Objects must be assigned an object type and belong to a product module. This facilitates setting up security based on object types and modules, rather than having to secure every object individually.

This table now supports both physical and logical objects. If the object is a physical object, then the link to the physical object will be set to 0. If the object is a dynamic object, then the link to the physical object will point at the object to use as the starting point when building the dynamic object.

If the object is flagged as a generic object, i.e. a physical object that is the basis for dynamic objects, then no security allocations, menus, etc. may be allocated to it as it is useless without the dynamic portions being built first against the logical objects that use it.

For logical objects, the object name will be specified without a file extension, and the path will not be relevant.

This repository concept means that many more objects will exist in this table.

" "object_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCOT" "object type" "gsc_object_type" yes "" 1004924413.09 "object_type_description" "" "This table defines the types of programs supported. A record will need to exist for the various support templates, e.g. ""Object Controller"", ""Menu Controller"", ""SmartFolder"", smartbrowser, smartviewer, smartdataobject, etc.

When objects are created, they must be assigned an object type.

The object type is used as a grouping mechanism for security, to allow restrictions to be created for certain types of objects, rather than having to setup security for every object.
" "object_type_obj" yes "object_type_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCPC" "profile code" "gsc_profile_code" yes "" 1004924373.09 "profile_description" "" "This table defines the codes that exist for each profile type, and the structure of the key / data value fields when this code is allocated against a user in the gsm_profile_data table.

An example profile type would be filter settings, and example profile codes for filter settings would be filter from values, filter to values, filtering enabled, filter field names, etc." "profile_code_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCPD" "package dataset" "gsc_package_dataset" yes "" 4621.24 "" "" "This table defines the datasets that should be included with a package. A dataset may be included in multiple packages." "package_dataset_obj" yes "package_dataset_obj" 4 "_" no yes yes "ICFDB" "" "" ""
"GSCPF" "profile type" "gsc_profile_type" yes "" 1004924374.09 "profile_type_description" "" "This table defines the types of profile codes supported for allocation to users.

Records will exist for any type of profile information stored against a user between sessions. Examples include browser filter settings, report filter settings, Toolbar cusomisation settings, window positions and sizes, system wide settings such as tooltips on/off, etc.




" "profile_type_obj" yes "profile_type_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCPM" "product module" "gsc_product_module" yes "" 1004924415.09 "product_module_description" "" "This table contains information about the installed product modules with appropriate license details." "product_module_obj" yes "product_module_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCPR" "product" "gsc_product" yes "" 1004924414.09 "product_description" "" "This table contains information about the installed products with appropriate license details." "product_obj" yes "product_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSCSC" "security control" "gsc_security_control" yes "" 1004924375.09 "" "" "Extra control information pertinent to security settings. This table will actually only contain a single record." "security_control_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCSN" "next sequence" "gsc_next_sequence" yes "" 1004924372.09 "" "" "This table is used to allocate sequence numbers where it is possible that multiple sequence numbers may be requested by multiple transactions simultaneously - it is intended to avoid deadly embrace record locks.

When a gsc_sequence is created / updated with multi_transaction set to YES, number_of_sequences records are created in this table starting from gsc-sequence.next_value.

When a sequence number is requested, the first record in this table for the gsc_sequence is found, saved and deleted. At the same time, a new gsc_next_sequence record is tagged on the end i.e. with the sequence number just found plus number_of_sequences." "next_sequence_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSCSP" "session property" "gsc_session_property" yes "" 1004924418.09 "session_property_name" "" "This table contains the list of valid properties that may be specified in the ""properties"" node of the ICF configuration file (ICFCONFIG.XML).

These property values can be set and retrieved using calls to the Session Manager. They can thus be used to alter the way that the session performs depending on the session type.
" "session_property_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCSQ" "sequence" "gsc_sequence" yes "" 1004924376.09 "sequence_description" "" "This is a generic sequence number / format table. All entries in this table will be system owned by their nature.

When a sequence number is required to be generated, it will be done at the end of the update as part of the transaction. This table is a potential bottle neck and so locks should be kept to an absolute minimum, i.e. no locks during user interaction.

If the sequence number is to be automatically generated, then there can be no holes in the sequence numbers, which is why a Progress sequence will not be used.

Example uses for this table would be for the automatic generation of document numbers, transaction references, etc." "sequence_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSCST" "service type" "gsc_service_type" yes "" 1004924417.09 "service_type_description" "" "This entity describes the different types of services available to applications and provides the management procedures for the different types of connections.

To illustrate, database services, AppServer services and JMS partitions are all different service types. The Database and AppServer services are system owned.

The maintenance object defines the datafield object used to maintain the physical connection parameter attribute on the physical service table. For example, if this is a service type for database connections, then the datafield may allow the specifiction of -S -N and -H prompts independantly and then put the result as 1 field into the connection parameter.

The management object is the api procedure that is responsible for making the physical connections to the service.

In the case of an appserver partition, the default logical service could point at the default logical appserver partition to use.

" "service_type_obj" yes "service_type_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMAV" "profile alpha value" "gsm_profile_alpha_value" yes "" 1004924388.09 "" "" "List of valid values / ranges for an alpha profile" "profile_alpha_value_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMCA" "category" "gsm_category" yes "" 1004924377.09 "category_description" "" "A multi-purpose grouping mechanism for generic entities. Certain categories may be system owned / generated and may not be deleted. These are usually hard coded into programs.

Additionally, some categories may not be associated with another generic entity. These are used to store hard coded valid value lists, lookup lists, etc. Where ever we have made use of hard coded mnemonics within the application, their usage and description will be defined in this table. 

Refer to the ""Generic Table Usage"" document for a detailed description and sample instance data." "category_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMCL" "control code" "gsm_control_code" yes "" 1004924378.09 "control_description" "" "This is a generic table for holding device control codes. The category is used to define what the code is for, and the owning_obj is optionally to define the device the code relates to. If the owning_obj is left as 0, then it applies to all devices.

An example use is in a point of sale system where codes must be sent to a pole for various reasons, e.g. to reset the poll, to make the message scroll, etc. Different categories would be defined for each action. The owning_entity_mnemonic on the category would determine which table the owning_obj related to. This will usually be some sort of application specific device table.
" "control_code_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMCM" "comment" "gsm_comment" yes "" 87 "comment_description" "" "Generic comment linked to any entity." "comment_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMCR" "currency" "gsm_currency" yes "" 1004924380.09 "currency_description" "" "This table contains all the currency codes and their symbol references that are available to the system" "currency_obj" yes "currency_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMCY" "country" "gsm_country" yes "" 1004924379.09 "country_name" "" "Supported countries, e.g. USA = United States of America, SA = South Africa, UK = United Kingdom" "country_obj" yes "country_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMDR" "default report format" "gsm_default_report_format" yes "" 1004924381.09 "" "" "This table provides an override mechanism for default report layouts. For example, specific organisations or people can specify a different default report format for a specific document type.

This would typically be used for login company organisations, where for each of the different login companies, a different statement print layout or cheque layout , etc. could be used by default." "default_report_format_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMEF" "entity field" "gsm_entity_field" yes "" 1004924382.09 "entity_field_name" "" "This table facilitates securing any application specific or generic data against any entity.

For example, if there is a requirement to secure access to specific companies, then the company entity, with the company code field could be set-up in this table. The valid values could then be setup in the entity field values table, and users allocated access to the specific values." "entity_field_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMEV" "entity field value" "gsm_entity_field_value" yes "" 1004924383.09 "" "" "The valid values for the entity field, e.g. company codes." "entity_field_value_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMEX" "external xref" "gsm_external_xref" yes "" 1004924384.09 "external_description" "" "This table defines generic cross reference information to details in external tables.

For example, an organisation whose accounts are held in this database, may have other account codes in an external database where these account codes originated from. This table could be used to define which internal accounts point to which external accounts for xref and reporting purposes. In this example, the fields would be setup as follows:
related entity = The gsm_organisation table in this database
related object = Specific organisations
Internal entity = The gsm_account table in this database
internal object = specific account codes

If an external table is available, then the external entity and object can be defined, otherwise the external details can be keyed directly into this table.
" "external_xref_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMFF" "field" "gsm_field" yes "" 103 "field_description" "" "Fields that require secured access in the software. Not many fields required security, but those that do should be defined in this table. Users can only be given restricted access to fields specified in this table.

If a user is given restricted access to a field specified in this table, then the access granted to the user may be view only, hidden, or update.

For field security to be activated, entries must be created in the security structure table, as it is this table that is allocated to users, and allows the field security to be restricted or different in various parts of the application.

Usually developers will create appropriate fields, and users may then assign them to certain parts of the application via the security structure table.
" "field_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMFS" "flow step" "gsm_flow_step" yes "" 1004924420.09 "" "" "This table contains the steps that have to be followed to complete a flow.

Each step may involve the running of an object, the running of an internal procedure within an object, or the execution of another complete flow.

The flow steps may be customised for specific login organisations so that entire steps may be replaced with custom specific code. 

The standard flow steps will be specified with a 0 login company. Within a single flow the login company can either be 0 or a specific company. When running each step it will first check for a customisation for the login company and if not found will just run the standard step. 

If a customisation is found, this may either be an additional step in which case the custom step will be run first, or else it will be a complete replacement of the standard step.

It is also possible to add custom steps that do not have any standard code at all, i.e. no step with a 0 login company exists. This facilitates adding customisations after the standard behaviour.





 and so setting up company specific steps would involve copying the default flow steps to a specific login company in full and then customising the specific steps as required. If the standard flow is modified, customised steps would also need to be manually modified as appropriate.
" "flow_step_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMFW" "flow" "gsm_flow" yes "" 1004924419.09 "flow_description" "" "A flow is a set of steps that have to be performed in a certain order to result in certain desired behavior. 

This table groups the steps that have to be performed.

af/sup2/afrun2.i takes a parameter (&FLOW) which maps to one of these flows and then executes the steps that make up the flow.

A flow must ultimately map to a single transaction and therefore must be executed on a single physical partition or service.

Example flows may be shipOrder, completeOrder, postTransaction, etc.
" "flow_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMHE" "help" "gsm_help" yes "" 1004924421.09 "" "" "This table defines help contexts for containers, objects on containers, and fields on obejcts if required.

When context sensitive help is requested, the context and help file will be retrieved from this file if available.

Help may be specified in multiple languages if required.

An entry in this table for a specific language but no container, object or field specified will override the standard help file used systemwide for the specified language from gsc_security_control." "help_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMIT" "menu structure item" "gsm_menu_structure_item" yes "" 1007600157.08 "" "" "This table associates menu items with menu structures. A menu structure may contain many menu items and a menu item can be used by many menu structures.

This tables also defines the sequence that menu items appear within a menu structure.
" "menu_structure_item_obj" yes "menu_structure_obj,menu_item_sequence" 4 "_" no yes yes "ICFDB" "" "" ""
"GSMLG" "login company" "gsm_login_company" yes "" 1004924385.09 "login_company_name" "" "This framework table defines login companies (organisations) and is used to provide a list of valid companies the user may log into at runtime.

It is intended that this table will link into an external application database where additional details will be stored for the login company, e.g. address and contact information. The code or the object field could be used as the xref into the external application database.

The table is required in the framework to facilitate the generic set-up of framework data specific to login companies, e.g. security allocations, automatic reference numbers, etc.

The existence of a login company in the framework supports the concept of holding multiple company application data in a single database as apposed to having separate databases for each company. Application databases would further have to link to this table or a corresponding table in their database design to filter appropriate data for each login company.

We only hold on this table the minimum details as required by the framework. Applications that also have an organisation table will need to replicate modifications from their full organisation table into this table in order to simplify and syncrhonise maintenance of this data.
" "login_company_obj" yes "login_company_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMMI" "menu item" "gsm_menu_item" yes "" 124 "menu_item_description" "" "This table defines the dynamic menu items that belong to a menu structure, and their hierarchy.

Menu items can be sub-menus, rulers, toggle options, or point to an actual program object to run." "menu_item_obj" yes "menu_item_reference" 4 "_" no yes yes "icfdb" "" "" ""
"GSMMM" "multi media" "gsm_multi_media" yes "" 1004924386.09 "multi_media_description" "" "Generic multi media file linked to any entity." "multi_media_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMMS" "menu structure" "gsm_menu_structure" yes "" 1004924422.09 "menu_structure_description" "" "This table defines the dynamic menu structues available. A menu structure must belong to a product, and can optionally also be associated with a product module if required - for sorting purposes.

The menu structure code will be referenced in source code to build any dynamic menu items associated with the menu structure." "menu_structure_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMND" "node_code" "gsm_node" yes "" 1005103085.101 "" "" "This table contains a parent-child relationship of node behaviour for the TreeView controller." "node_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMNV" "profile numeric value" "gsm_profile_numeric_value" yes "" 1004924393.09 "" "" "List of valid numeric values / ranges for a profile.

For other systems, this table is also used for determining contribution rule values e.g. for age or income ranges in conjunction with a hard coded category. The rule value used would be the numeric_value_to.
" "profile_numeric_value_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMOM" "object menu structure" "gsm_object_menu_structure" yes "" 1004924423.09 "" "" "This table defines the dynamic menu structures used by the object - if applicable. Only container objects may have dynamic menu structures.

If an instance attribute is specified, then the menu structure will only be dynamically built if the instance attribute is passed in from the previous menu option.

This facilitates pulling in different dynamic menu options for a specific object based on its use, e.g. creditors, debtors, etc. having different options.

" "object_menu_structure_obj" yes "object_obj,menu_structure_obj,instance_attribute_obj" 4 "_" no yes yes "icfdb" "" "" ""
"GSMPA" "profile alpha options" "gsm_profile_alpha_options" yes "" 1004924387.09 "" "" "Alpha specific details for a profile" "profile_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMPD" "profile date value" "gsm_profile_date_value" yes "" 1004924390.09 "" "" "List of valid dates / date ranges for a profile" "profile_date_value_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMPF" "profile data" "gsm_profile_data" yes "" 1004924389.09 "" "" "This table is used to store profile information for specific users, e.g. browser filter settings, window positions and sizes, report filtter settings, etc.

The nature of the data key and data value fields is determined by the profile type and code.

Data can be stored permannently, or only for the current session, depending on the context_id field." "profile_data_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMPH" "profile history" "gsm_profile_history" yes "" 1004924391.09 "" "" "History of profiles relating to an object from the effective date onwards.

In other systems, in the case where a profile is related to contribution rule value determination, the value fields are not applicable." "profile_history_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMPN" "profile numeric options" "gsm_profile_numeric_options" yes "" 1004924392.09 "" "" "Numeric specific options for a profile." "profile_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMPR" "profile" "gsm_profile" yes "" 143 "profile_description" "" "Generic profiles that can be attached to any entity or may stand alone to be used as control information or lookup lists. Profiles could be utilised for user defined fields e.g. smoking and drinking habits of members.

For other systems, the modification of a profile and it's related tables must be inhibited where it exists in any s_contribution_type.rule_code_profile_objs with existing s_contribution_rules records." "profile_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMPY" "physical service" "gsm_physical_service" yes "" 1004924424.09 "physical_service_description" "" "A physical service provides the specific connection parameters that are required to connect a physical service to a session.

The physical service is connected to a logical service and session type via the session service.

The maintenance object on the service type defines the datafield object used to maintain the physical connection parameters attribute. For example, if this is a service type for database connections, then the datafield may allow the specifiction of -S -N and -H prompts independantly and then put the result as 1 field into the connection parameters.

The management object on the service type is the api procedure that is responsible for making the physical connections to the service.
" "physical_service_obj" yes "physical_service_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMRA" "range" "gsm_range" yes "" 146 "range_description" "" "These are range structures that control what data a user may view. When allocated to a user, the ranges of permitted data will be specified.

Sample range structures could include ""Nominal Codes"", ""Cost Centres"", or ""Member Codes"", etc.

The appropriate data will be hidden from the user.

For range security to be activated, entries must be created in the security structure table, as it is this table that is allocated to users, and allows the range security to be restricted or different in various parts of the application.

Usually developers will create appropriate ranges, and users may then assign them to certain parts of the application via the security structure table.
" "range_obj" yes "range_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMRD" "report definition" "gsm_report_definition" yes "" 147 "launch_window_name" "" "This table contains control and default  information about all the reports produced by the system.

Note that all reports will be created by initially extracting a delimited data file which could then be printed using any reporting tool.

This table actually defines the report extract procedure and default report options. The extract can the be printed in various formats as defined by the gsm_report_format table.

The name of the extract file(s) produced will be hard coded in the extract procedure, but will be derived from the extract procedure name. The extension will be .rpd suffixed with the date and time down to seconds for multi-user support. The actual names used will be recorded in the gst_extract_log." "report_definition_obj" yes "report_definition_reference" 4 "_" no yes yes "icfdb" "" "" ""
"GSMRE" "reporting tool" "gsm_reporting_tool" yes "" 1004924425.09 "" "" "This table contains information about the reporting tools available to the system. These would be:
Progress
Results
Crystal reports
Actuate
etc." "reporting_tool_obj" yes "reporting_tool_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMRF" "report format" "gsm_report_format" yes "" 149 "report_format_description" "" "Once data for a report has been extracted, it may be printed in different formats using different reporting tools.

This table defines the report procedures that may be used to format the extracted data. If printing to Crystal, the report fromat procedure is the name of the Crystal Report definition file.

The extract files to send as data to the report will be hard coded in the report extract procedure." "report_format_obj" yes "report_format_reference" 4 "_" no yes yes "icfdb" "" "" ""
"GSMRM" "required manager" "gsm_required_manager" yes "" 1004924426.09 "" "" "This table contains a list of the managers that are required to be started during the startup of the session and the order in which they must be started. Any manager types which need to be written to the config file must always be started first. 

The write_to_config attribute of the manager will cause this procedure name to be written to the config.xml file so that it can be started up before the session makes a connection to the runtime repository.

The framework supports a standard set of managers that are required but specific applications may require the startup of additional managers for performance reasons, e.g. a financial system may require a frequently referenced financial manager api to be pre-started." "required_manager_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMSC" "server context" "gsm_server_context" yes "" 1004924427.09 "context_name" "" "This table is a generic table to stored context information between stateless appserver connections.

The type of information that is required includes user information, security information, possibly SCM workspace and task information, etc.

" "server_context_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMSE" "session type" "gsm_session_type" yes "" 1004924429.09 "session_type_description" "" "A session type is a namespace for grouping specific types of sessions together.

For example, a ""receipting workstation"" would be a specific session type while a ""salesman's web agent"" could be another.

Each session type is combined with a physical session type that maps to a list of known Progress 4GL run-time environments. 

Thus, ""receipting workstation"" may be mapped to a 4GL GUI client while ""salesman's web agent"" could be mapped to a WebSpeed Transaction Agent.

Thus you could create any number of session types mapping them to specific 4GL session types.

Where different managers, etc. need to be pre-started for different applications, then the different applications would be defined as new session types.

In order to run locally without appserver connections, etc. you would need to define a new session type that connects to appropriate databases and has no session service records for the appserver logical services thereby forcing them to not connect and rather simply use the session handle for code portability. Also, this new session type would define a different set of managers to run, i.e. run the server side managers locally.

We will provide a facility to change the session type on the fly (if possible).

" "session_type_obj" yes "session_type_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMSF" "startup flow" "gsm_startup_flow" yes "" 1004924432.09 "" "" "This table defines a list of flows that have to be run at startup of the session after the management procedures have been initialized, in order to perform any specific session setup, e.g. caching of various information." "startup_flow_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMSH" "status history" "gsm_status_history" yes "" 1004924396.09 "" "" "Actual status of an object as from the effective date" "status_history_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMSI" "site" "gsm_site" yes "" 1004924431.09 "site_name" "" "This table contain sites or locations where ICF software is running.

Its use is to make certain data specific to a particular site, e.g. menu items, menu structures, report definitions, report formats, etc. specific to ICF. It can further define data specific to product and product modules.

Sites could be further broken down to provide additional filtering by site location if required.

Sites can either be development sites or customer sites. Only development sites need a unique site number.

Every site you intend to deploy data to needs to be set up in this table as the site is used to track deployments.

Every site must be allocated a totally unique number worldwide. This number will then be used as part of the object numbers in any databases used by that site for ICF applications.

This will mean that you can safely deploy data to sites without fear of having conflicting object numbers. Any data modified by the site will never be overwritten as the object numbers will never clash. Also data could be returned to us safely with no fear of object number clashes.

The site number must be uniqe worldwide to facilitate software houses developing with ICF releasing data to other software houses developing with ICF

The ICFDB will contain two sequences, seq_site_reverse and seq_site_division that will have their current value set by the allocation of the site number. They will then never be changed, and the current value of the sequences used to calculate the decimal portion of the object number, making the object numbers unique within that site. See the description of the site number for details of the calculations required.

A site will only ever have one version of the ICFDB database, ensuring they keep the same site number for all their ICF products.

Any object numbers that do not conform to this new standard should be fixed immediately to avoid problems in the future.

The data is linked to a site via the gsm_site_specific table in the ICFDB database which supports any type of data. The data being filtered is identified by the owning entity mnemonic, and the specific reference identifies the actual item of data being filtered. It is possible to make an item of data available to many sites. If the item of data does not exist in the table, then it will be assumed the data is applicable to all sites.

The gsm_site_specific table is also used to allocate which sites a specific user is associated with. In this case the entity mnemonic would be GSMUS and the specific reference would be the user login name.

Examples of data that may be specific to site codes are menu items, menu structures, report definitions and report formats.

For any supported tables, e.g. menu items when building menus, a check will need to be made in the site specific data table for the appropriate entity mnemonic and unique reference. If any records exist at all, then the site codes allocated to the user must be checked to see that the user has a matching site code. If not, the data should be skipped over as it is not relevant.

This table is in ICFDB because it is not specific to any product or workspace. The site specific data table is in ICFDB because it relates to the specific product and workspace data, allowing different workspaces to support different configurations of site specific data.

The current site can always be found by checking the value of the site sequence." "site_number" yes "site_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMSP" "site specific" "gsm_site_specific" yes "" 1004924395.09 "" "" "This table defines data that is specific to a site or location where ICF is running, e.g. ICF, POSSE, PCS, etc.

Additionally the data may be specific to a product or product module.

Its use is to make certain data specific to a particular site, e.g. menu items, menu structures, report definitions, report formats, etc. specific to ICF.

The data being filtered is identified by the owning entity mnemonic, and the specific reference identifies the actual item of data being filtered. It is possible to make an item of data available to many sites. If the item of data does not exist in the table, then it will be assumed the data is applicable to all sites.

This table is also used to allocate which sites a specific user is associated with. In this case the entity mnemonic would be GSMUS and the specific reference would be the user login name.

Examples of data that may be specific to site codes are menu items, menu structures, report definitions and report formats.

For any supported tables, e.g. menu items when building menus, a check will need to be made in the site specific data table for the appropriate entity mnemonic and unique reference (e.g. menu item reference). If any records exist at all, then the site codes allocated to the user must be checked to see that the user has a matching site code. If not, the data should be skipped over as it is not relevant.

This site table is in RVDB because it is not specific to any product or workspace. This table is in ICFDB because it relates to the specific product and workspace data, allowing different workspaces to support different configurations of site specific data.

A standard folder with a 2 selection list viewer must be developed to allow the generic allocation of site codes for a specific item of data by passing in an instance attribute for the entity mnemonic. Also a standard api should be developed to check for the existence of data in this table and whether the user has a matching site code. To avoid checking the user site codes all the time, they should be placed into the extra user login value variables." "site_specific_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMSS" "security structure" "gsm_security_structure" yes "" 1004924394.09 "" "" "The parts of the application where security restrictions are applicable to. Currently access tokens, fields, and ranges are supported. The owning_obj will refer either to a gsm_token record, a gsm_field record, or a gsm_range record.

One table is used rather than a usage table for each of the above as the fields are identical, and if another type is introduced, no major rewrites will be required as this table will automatically support it.

The security restriction may be assigned globally, in which case the product module, object and instance attribute will be 0.

Alternatively the restriction may be allocated to a product module, a specific program object, or even an insance attribute for a program.

A restriction must be assigned to this table for it to be active at all. It is entries in this table that are allocated to users.
" "security_structure_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMST" "status" "gsm_status" yes "" 160 "status_description" "" "The actual valid status codes are set-up in the category table. For example:

related entity mnemonic = GSMST for gsm_status
category type = STS for Status
category group = HST for History
category subgroup = COD for Code

The category subgroup is the actual status in this case. The categories of status will always be system owned and mandatory. The category mandatory flag will be used to indicate whether an object at this status may be modified.

At least 1 record must exist in this table for every category subgroup that has a related entity mnemonic of status (GSMST). This record will be system owned, have a sequence of 0 and may not be deleted. It will always be the default status for this category subgroup.

This table allows users to modify the narrative of the status, and add extra status's within the same category subgroup to represent their internal business processes.

From a business logic point of view, when the status changes within the same category, we do not need to do anything and the user may do this manually via a combo box. The change of status from 1 category to the next within a category group will usually be done via a business logic process.

We will always need to join back to the category table to determine what status an object is at from a business logic point of view.

The status an object is at effective from a specific date is determined by an entry in the status history table, which means the status does not need to be added to every table it is used for. However, in some cases we have linked objects directly to the status table to show the current status for performance reasons." "status_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMSV" "session service" "gsm_session_service" yes "" 1004924428.09 "" "" "The session service table defines the different physical services for each session type in order to establish the logical service.

For example, an AppServer may require a shared memory connection to the repository database whereas a client session would require a network connection to the same databases. The physical connection parameters are different for each of these. Therefore the logical service identifies the database that needs to be connected and the physical service describes the mechanism for the connection dependant on the session type.

If no session service record exists then the logical service can only run locally.
" "session_service_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMSY" "session type property" "gsm_session_type_property" yes "" 1004924430.09 "" "" "This table resolves the many-to-many relationship between gsc_session_property and gsm_session_type.

If a record is found in this table for a property and a session type, the value specified in that record is written to the ICF configuration file for the parameter.

If no record exists for a given property and session type, the always_used flag on the gsc_session_property table is checked. If the flag is on, the default value in the default_property_value field on the gsc_session_property table is used." "session_type_property_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMTL" "translation" "gsm_translation" yes "" 1004924397.09 "widget_name" "" "This table containes user defined translations for the various languages for widget labels and tooltip text.

The setup of every program will first walk the widget tree and change the label / tooltip to the entry in this table according to the language selected by the user - if an entry exists.

Translations can be turned off globally using the gsc_security_control.translation_enabled flag.
" "translation_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"GSMTM" "toolbar menu structure" "gsm_toolbar_menu_structure" yes "" 1007600089.08 "" "" "This table is used to group bands or menu structures into a complete toolbar and menubar structure." "toolbar_menu_structure_obj" yes "object_obj,menu_structure_sequence,menu_structure_obj" 4 "_" no yes yes "ICFDB" "" "" ""
"GSMTO" "token" "gsm_token" yes "" 164 "token_description" "" "Tokens are used in the application to control access to functions the user may perform within a program via tab folder page names and button names.

Tokens may be created for any tab page names or button labels, being careful to ignore any shortcut characters and ... suffixes. The tokens must then be added to the security structure table to become active. The security structure table facilitates the token being restricted for a specific object instance, specific object, specific product module, or generically for everything.

The software will only check security providing a valid enabled token exists for the button label or tab folder page.

If a user has no tokens allocated at all, then it is assumed they have full access (providing security contol is set to full access by default). Once a user is allocated tokens, then security comes into force and the user will only be granted access for folder pages and buttons they have been granted access to (an that have restricted access set up).

Example tokens would be add, delete, modify, view, copy, page 1, page 2, etc.
" "token_obj" yes "token_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMUC" "user category" "gsm_user_category" yes "" 1004924400.09 "user_category_description" "" "This table defines categories of users. It could be used for job functions, etc. It's primary use is for filtering and reporting." "user_category_obj" yes "user_category_code" 4 "_" no yes yes "icfdb" "" "" ""
"GSMUL" "user allocation" "gsm_user_allocation" yes "" 1004924399.09 "" "" "When a user logs into the system, they log in with a user id, and a select a company (organisation). This table defines the security options for the user when they log into a certian organisation. The user may have different security options when logged into different companies.

If the organisation_obj is 0, then the security allocation applies to all companies. Likewise, if the user_obj is 0, then the security allocation applies to all users logged into this company. User security will always override company security. In addition, and owning_obj of 0 always indicates no access to all the data for that entity mnemonic (not supported for security structures, or menus - only really for data).

This table generically assigns all security options for the user / company. The standard options that may be specified via the owning_entity_mnemonic and owning_obj are:

gsm_security_structure records for security relating to tokens, fields and ranges.
gsm_menu_items for securing access to menu items
gsm_menu_structure for securing access to menu structures
gsm_entity_field_value for securing access to generic entity field values e.g. companies.

Additionally, access to any entity data can be secured using this table. For example, to secure access to specific cost centre codes in a general ledger, the owning_entity_mnemonic could be the cost centre table, and the owning_obj used to allocate specific cost centres the user / company has access to.

The rules applied to this table for the entity in order are as follows:
0) If security is disabled, then user security is passed.
1) If a specific record exists for the user / company then security is passed
2) If a specific record is found for the user / company with an owning_obj of     0, security is failed
3) If not full access by default, and no entries exist for the user at all, including     all users and all companies, security is failed
4) If a record exists for all users or all companies with an owning_obj of 0,     then security is failed
5) If a record is found for all users, security is passed
6) If a record is found for all companies, security is passed
7) If full access by default and no records are found at all for the specific     user, all users, or all companies, then security is passed.

Some allocations require additional data, e.g. allocating a field restriction needs to determine what can be done with the field, e.g. View, Update, Hide, etc.

Entries must exist in this table for all security allocations. There is no option for inclusion or exclusion to make querying as fast as possible. The maintenance programs however should allow the specification by inclusion or exclusion for fast data entry - then create / delete all relevant entries in this table.
" "user_allocation_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMUS" "user" "gsm_user" yes "" 1004924398.09 "user_login_name" "" "This table defines the users who may log into the system, i.e. the users of the system.

The main user details are contained in an external security system, e.g. openstart pointed at by the external_userid field. This table defines extra user information for this system, and allows a user to be optionally associated with a person to facilitate full name, address, etc. details to be entered for a user as well as comments.

There is a logged in flag on this user record to facilitate the identification of user availability (a user is available if they are logged into this application).

The existence of this specific user table in our database also facilitates automatic referential integrity.

" "user_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSMVP" "valid object partition" "gsm_valid_object_partition" yes "" 1004924436.09 "" "" "This table defines a list of valid partitions in which a procedure can be run.

A partition is a logical AppServer Partition.

The list only contains records when the object is restricted to certain partitions. When the object may be run on any partition, there are no records in this table.

The records in this table are only applicable to appserver session types." "valid_object_partition_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSTAD" "audit" "gst_audit" yes "" 186 "" "" "Global audit file to record modifications to data. The audit can be turned on by defining a category of audit for an entity type. It can be turned off again simply by resetting the active flag on the category.
The audit will hold basic details on the action (create, amend, or delete), the user, date & time, the program and procedure used to perform the action, and possibly a record of the data before the update.
The audit could easily be used to keep old values of fields by defining more categories, e.g. one for each field or group of fields on an entity." "audit_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSTBT" "batch job" "gst_batch_job" yes "" 1004924401.09 "" "" "A job can be run immediately or at a user selected time in which case it is stored as a batch job. A daemon will monitor this table and initiate the jobs at the selected time.

The batch_job_procedure_name may be the same as a report_procedure_name, or it may be for a separate procedure that initiates a number of separate procedures. These may or may not be report_procedure_name's.

Parameters for the batch job will be stored as per those for the report definition." "batch_job_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSTDF" "dataset file" "gst_dataset_file" yes "" 4623.24 "" "" "This table keeps a record of ADO files generated for a dataset. A single dataset may be generated out to multiple ADO files.

The purpose of this table is to record the date and time this dataset ADO file was last loaded into the current repository. Checks will be made against the file date on disk to see whether a new files has been downloaded from POSSE and needs to be updated into the local repository.

If an ADO file is included as part of a package, this table records the package that the ADO file belongs to." "dataset_file_obj" yes "dataset_file_obj" 4 "_" no no no "ICFDB" "" "" ""
"GSTDP" "deployment" "gst_deployment" yes "" 4627.24 "" "" "This table defines an instance of a deployment package, from a particular site. Records in this table may be manually created for the curent site, or may be imported as part of loading a deployment package from an external site." "deployment_obj" yes "deployment_obj" 4 "_" no no no "ICFDB" "" "" ""
"GSTEL" "extract log" "gst_extract_log" yes "" 1004924403.09 "" "" "Each time a data extract report is run, an entry is created in this file. The main intention is to track the completion of extract procedures so that report formatting procedures can be initiated where required.

In the event that an extract log record is deleted, then any document produced records associated with the extract should be cascade deleted, providing that the print date has not been set - in order to tidy up the data." "extract_log_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSTER" "error log" "gst_error_log" yes "" 1004924402.09 "" "" "This table holds a list of errors generated either from business logic or user interface code.

The table will be periodically archived to ensure it does not get too huge.

The data in the table will be fed direct from the user interface, and periodically fed by the business logic error file which will be a flat file due to the fact that we cannot write direct to this table as the write would form part of the transaction being undone.." "error_log_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSTPH" "password history" "gst_password_history" yes "" 1004924404.09 "" "" "This table keeps a history of previous passwords used by users. It is used for audit purposes, and preventing users using the same password within a given time period, e.g. 1 year." "password_history_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"GSTRV" "record version" "gst_record_version" yes "" 1004927721.09 "" "" "This table provides the means for identifying when static data is changed and needs to be deployed. 

When an item of data on a record changes, the replication trigger on the table will check if the version_data flag on the gsc_entity_mnemonic table is switched on. 

If the flag is on, either a record is written to this table or an existing record in the table is updated to indicate that the data has changed by incrementing the version_number_seq and resetting date, time and user. 

This table is checked every time the deployment data is written to ensure that all data that matches the deployment criteria is written out.

If no record exists for a record that is supposed to be deployed, it is assumed that this data already exists in the remote database because it would have been created from a baseline or initial installation." "record_version_obj" yes "record_version_obj" 4 "_" no no no "icfdb" "" "" ""
"GSTTO" "trigger override" "gst_trigger_override" yes "" 0 "table_name" "" "This table facilitates the generic override of triggers for any table in the database. 

It is required because the trigger override statements can not be done generically. It also offers more flexibility over which triggers to override. Any comination of triggers is supported with * for all, e.g.

create
delete
write
find
replication-create
replication-delete
replication-find
replication-write

Standard checks are included into triggers via the include file af/sup2/aftrgover.i which references this table and does a can find check on the table name, the transaction id (from dbtaskid) and also checks for a date range of 2 days from the current system date to ensure we do not find redundant data.

A transaction id as generated from the dbtaskid statement. This is used so that the override functionality only works within the context of a single transaction.

Records must therefore be created in this table within the same transaction that the triggers need to be overridden.

Extra information is included in the table for audit purposes to track down problem areas if records get left in this table.

One area where this is used is when dumping / loading data via xml files for deployment datasets that require ri triggers to be disabled.

" "trigger_override_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"RVCCT" "configuration type" "rvc_configuration_type" yes "" 1004924350.09 "type_description" "" "This defines the types of data item which require version control.  Each type should correspond to a single database table.  Any alteration to this table or its direct children will be versioned, and require the item to be checked out.  This is achieved by having suitable REPLICATION triggers on all involved tables.

e.g. ryc_smartobject (and it's related tables: ryc_page, ryc_smartlink, etc.).

In this case the SmartObject is a configuration type.  Any changes to records in ryv_smartobject, ryc_page etc.  will result in a new version of that smartobject.  

The log records maintained are sensitive to schema changes in any of the invoved tables.  Utilities will be provided for restructuring these log entries in the event that version recovery is desired across schema changes.

Fields exist in this table for integration with a SCM tool, e.g. Roundtable. They identify the identifying field in the table that maps to the object name in the SCM tool. They then identify which fields form the primary key to enable a simple cross reference between the SCM object and the primary key of the data. For example, in the ryc_smartbject table, the identify field would be object_filename and the primary key fields would be smartobject_obj. This means that we could find a smartobject record using the object filename and get the smartobject object number." "configuration_type_obj" yes "configuration_type" 4 "_" no no no "rvdb" "" "" ""
"RVMCI" "configuration item" "rvm_configuration_item" yes "" 1004924351.09 "scm_object_name" "" "This is a particular item of data under version control e.g. a particular smartobject. 

Configuration items must belong to a product module.  The configuration type dictates the type of data, and the object name represents the identifying field of the record in the table - also as used for the object name in the SCM tool.
" "configuration_item_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVMTA" "task" "rvm_task" yes "" 1004924433.09 "" "" "This table replicates the rtb_task table in the Roundtable repository. Its purpose is so that we can add extra fields to the task table, and also add our own indexes for optimum performance with our test status tracking.

We have duplicated the fields from the rtb_task table to avoid having to join to it, plus to allow additional indexing on the fields within it.

The main additions are for actual and estimated hours, current test area and status to track the progress of the task through the workspaces.

Any actions peformed on rtb_task must be done on this table also, and vice-versa, as the tables should be viewed as a single table." "task_number" yes "task_number" 4 "_" no no no "rvdb" "" "" ""
"RVMTB" "task object" "rvm_task_object" yes "" 1004924435.09 "task_object_name" "" "This table defines the object versions that were worked on in a task. It is similar to the rtb_ver table in Roundtable, but holds different information for test status tracking and additional indexing.

In this table, we are only interested in PCODE objects, not schema, as schema is always changed outside Roundtable in ERwin and changes stored in incremental df files. We do not need to track testing over schema changes, we rather need to track the program changes made to implement the schema changes, which will be in a seperate task.

Also, this table only contains objects that have been checked in under a task, as until they have been checked in, no test status tracking is required and the object may be deleted." "task_object_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVMTY" "task history" "rvm_task_history" yes "" 1004924434.09 "" "" "This table records a history of the different test status's and areas the task has progressed through, recording the date, time and user, and allowing additional recording of notes and hours for each stage of the tasks lifecycle." "task_history_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVMWI" "workspace item" "rvm_workspace_item" yes "" 1004924353.09 "scm_object_name" "" "This table defines which item versions exist in a specific workspace.

Where an item is being worked on in the workspace, this table will record both the current version number and the wip version number.  The wip version is available in the database, but may not be checked back in, in which case the wip version recorded here will revert to the current version.

The wip version number will only contain a value whilst the workspace item is checked out under a task, otherwise it will be 0.

When moving items between workspaces, only the item version number will be used. A modification must be completed (checked in) before it can progress to any other workspace." "workspace_item_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVMWM" "workspace module" "rvm_workspace_module" yes "" 1004924354.09 "" "" "This table defines the product modules that belong to a particular workspace, and whether the product module is primary or sourced from a different workspace.

If a product module is primary to this workspace then the data versions should ordinarily be modified within this workspace.  If the product module is not primary, then the data versions should ordinarily be modified in their source workspace and imported into this workspace.  These rules may not be rigorously enforced.

" "workspace_module_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVMWS" "workspace" "rvm_workspace" yes "" 1004924352.09 "workspace_description" "" "This is the definition of a workspace, which is a specific configuration of item versions (in this case the items represent data).  Item versions exist outside the context of a workspace.  Workspaces are used to control the various stages of the development process, typically including Development, Test and Deployment areas.  They also exist to manage customer-specific configurations (e.g. what specific products and versions thereof a customer is running).  

If a workspace becomes obsolete then it can be deleted.  This does not delete the items or their versions, but merely the record of what versions were in the particular workspace.

If using Roundtable, these workspaces should correspond to those in Roundtable itself.

It is possible to check out an entire workspace if desired.

In the first version of the Versioning system we are going to be heavilly dependant on Roundtable integration.  Smartobject records correspond to logical gsc_object records which are actually checked out in roundtable  We will not initially support versioning of orther configuration types.
" "workspace_obj" yes "workspace_code" 4 "_" no no no "rvdb" "" "" ""
"RVTAC" "action" "rvt_action" yes "" 1004924355.09 "" "" "This table contains entries for every action (CREATE, WRITE, DELETE) for all involved tables in the database.  Actions form parts of a transaction, which must be assigned to a task.

The information stored in the action table is sufficient to replay that action at some later stage: The name of the table, the action, and the raw-transfer data representing the action.

Action entries rely on a raw-transfer operation for the efficient construction of data.  This is sensitive to schema changes in the involved tables.  Utilities will be provided to restructure log entries when version recovery is required across schema changes.
" "action_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVTAU" "action underway" "rvt_action_underway" yes "" 1004924356.09 "action_scm_object_name" "" "This table will only contain records during a  transaction for some acrtion, e.g. deletion, assignment, etc. Its purpose is to make primary table information available to involved tables during the operation, e.g. cascade deletion, object assignment, etc.

The problem is that during a deletion of the primary table, the involved tables replication triggers can not access the primary table anymore, as it has been deleted.

To resolve this issue, we will create a record in this table at the top of the delete trigger of a primary table, and subsequently delete the record at the end of the primary table replication delete trigger. This means the information will be available throughout the entire delete transaction.

For the assignment of data between repositories via the versioning system, we need to know we are doing the assignment and ensure we do not fire off replication code to create transaction and action records, as it is simply moving existing versions of data rather than changing data.

Under normal cicumstances (no active transaction), this table will be empty." "action_underway_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVTDI" "deleted item" "rvt_deleted_item" yes "" 1004924357.09 "scm_object_name" "" "This table records items that were deleted from a workspace in the context of a task. Only registered items that are deleted from a workspace need to be recorded in this table.

The purpose of this table is to provide the SCM tool with the information required to delete its corresponding item from its repository, probably as part of some task completion process.

The SCM tool should remove this record once it has actioned the deletion in its own repository.
" "deleted_item_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVTIV" "item version" "rvt_item_version" yes "" 1004924358.09 "item_description" "" "This represents a single version of a configuration item.  At least one version must exist for the item.

New versions are not created when an item is checked out, but only when an item that has been checked out is first modified.

Once a version has been checked in it may not be deleted.  We may provide archiving facilities, but in principle the item version still exists.





" "item_version_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVTTR" "transaction" "rvt_transaction" yes "" 1004924359.09 "scm_object_name" "" "This table, in conjunction with rvt_action, contains the information required to construct an item version (including all related table information) from its previous version. The construcrtion of an item version may span multiple transactions.

This table defines all transactions that occur on involved tables in the database. Involved tables means the table being version controlled, plus all its related tables.

We assume in this model that a single transaction affects only a single item version within a single task. This means you cannot have a single transaction that would delete for example many records in a versioned table. Each deletion would need to occur in a seperate transaction. The reason for this is that a single transaction spanning multiple objects and versions would cause massive complexity in the roll forward behaviour.

We also assume that the transaction id is unique within a task. We do not assume it is unique universally (which it would not be).

The storing of the transaction id enables us to reproduce all updates performed in the context of a single transaction. When rolling forward the updates in a single transaction, we will disable all triggers, as the transaction will already include all updates that resulted from the initial firing of the triggers for related tables, e.g. cascade deletes, update of statistical information, etc.

Note: the update of statistical information on unrelated tables will not be performed automatically.

We assume that the transaction_id is in ascending sequence, and that groups of actions should be performed in this sequence.  Within the sequence, all actions with the same transaction_id form part of the same physical transaction.  Experience will dictate whether this sequencing is valid.

The deletion of an item of data in the primary table will not generate transaction and action records. The replication of this deletion between repositories will be handled by the SCM Tool (via import /assign hooks).
" "transaction_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RVTWC" "workspace checkout" "rvt_workspace_checkout" yes "" 1004924360.09 "" "" "This table defines the configuration items that are checked out in the various workspaces. When the item is checked back in, this record will be deleted.

A check_out record can be considered to be a licence to change the item and associated data. 

The checkout of an item should also create a new rtv_item_version record and assign that to be the task version for that item in the workspace." "workspace_checkout_obj" yes "" 4 "_" no no no "rvdb" "" "" ""
"RYCAC" "action" "ryc_action" yes "" 1004924437.09 "" "" "This table defines the actions available to place on a toolbar. Actions are organised into bands and whole bands are always allocated to toolbars rather than individual actions. An action however may be included in many bands.

Example toolbar actions would include navigation - first, next, previous, last, tableio - add, delete, modify, view, copy, etc. etc.

All actions in this table are standard actions available to all applications using the repository.
" "action_obj" yes "action_reference" 4 "_" no yes yes "icfdb" "" "" ""
"RYCAP" "attribute group" "ryc_attribute_group" yes "" 1004924439.09 "attribute_group_name" "" "This table facilitates the logical grouping of attributes to simplify their use, e.g. geometry, statusbar, etc. The primary use of this table is make the presentation of the attributes to the user more effective and usable. It is likely we could use a tree view, with attribute groups as a node and pressing plus on the group, showing all attributes within that group." "attribute_group_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCAT" "attribute" "ryc_attribute" yes "" 1004924438.09 "" "" "This table defines the attributes that may be allocated to smartobjects, e.g. size, position, window title, query, where clause, etc. They are used to defined the properties of dynamic objects, plus to dynamically alter the behaviour of static objects.

Certain attributes are required for the application to function correctly and these will be set to system owned to prevent accidental deletion. Only users that are classified as able to maintain system owned information may manipulate this data. In many cases, the actual attribute label will need to match to a valid Progress supported attribute.

Default attributes may be defined for the various smartobject types in the type attribute table, plus additional attributes allocated for each instance of a smartobject, thus the types define default bahaviour that may be overriden and extended for each instance.

Due to the powerful feature of allowing attributes to be defined at various levels, most dynamic data about smartobjects will utilise attributes.

Example areas that we will utilise attributes for include browser query, sort order and where clauses, container window titles, which window to run based on various button actions in a browser, e.g. add, modify, view, etc., status bar configuration, page enabling and disabling, field enabling and disabling by object instance, whether toolbar items are included in the menu, etc.

" "attribute_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCAV" "attribute value" "ryc_attribute_value" yes "" 1004924441.09 "" "" "This entity associated attributes with object types, smartobjects, and smartobject instances, and specifies the value of the attribute.

Where the attribute is associated with an object type or a smartobject, then the attribute value will reflect a default value. where the attribute is associated with an instance of a smartobject, then the value will reflect an actual value.

When creating entries in this table for attributes associated with an object type, then the smart object and instance will be 0.

When creating entries in the table for a smartobject, we will also populate the object type field to avoid having 0 in the key. Likewise when creating attributes for an object instance, we will populate the object type and the smartobject. This ensures effective use of the alternate keys.

Note: We must be careful when looking for attributes associated with an object type to ensure we look for the specific object type and 0 values for the smartobject and instance fields.

Where an attribute is defined as a collection, then attribute values can be linked together. The ""attribute_value"" field of the collection attribute_value record will be the number of elements in the collection, and this will then parent each of the attribute value records in the collection by collection sequence.

Where attribute values are defined for object types and smartobjects, these values will be cascaded down to actual smartobject instances for performance reasons. Any future modifications of these values will also be cascaded down to all instances where the inherrited_value is set to YES, therefore ensuring we do not overwrite manual changes made at an instance level.
" "attribute_value_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCAY" "attribute type" "ryc_attribute_type" yes "" 1004924440.09 "attribute_type_description" "" "This table defines the types of attributes supported. Attribute types then define the structure of values associated with attributes of this type. Example attribute types could be:

CHR = Character
COL = Collection
IMG = Image (so we can search/preview)
FIL = File (so we can search)
" "attribute_type_obj" yes "attribute_type_tla" 4 "_" no yes yes "icfdb" "" "" ""
"RYCBA" "band action" "ryc_band_action" yes "" 1004924443.09 "" "" "This table defines the actions allocated to bands. an action may be allocated to many bands, and a band may include many actions.

This table facilitates the re-use of actions in many bands. If multiple bands are included on a toolbar, and duplicate actions occur then this will be ignored and the user must re-organise the band actions accordingly." "band_action_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCBD" "band" "ryc_band" yes "" 1004924442.09 "band_name" "" "This table provides a grouping mechanism for related toolbar actions, e.g. navigation, update, browse, desktop, system, etc. They equate to toolbar bands and each band will likely be demarkated with seperators for clarity.

Bands are allocated to the dynamic toolbar using instance attributes." "band_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCCT" "custom ui trigger" "ryc_custom_ui_trigger" yes "" 1004924444.09 "" "" "This table facilitates the generic allocation of UI triggers to individual fields and frames directly from the repository. For example, we could define an event to publish or a procedure to run when a specific button is pressed on a specific viewer.

The actual code would have to already exist or reside in a super procedure." "custom_ui_trigger_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCLA" "layout" "ryc_layout" yes "" 1004924445.09 "layout_name" "" "This table defines the available page layouts for pages on smartfolder windows, e.g. 1 browser with 1 toolbar underneath, n viewers above each other, 2 side by side viewers, 2 side by side browsers, etc.

It also defines the available frame layouts for objects on a frame, e.g. 1 column, 2 columns, etc.

The purpose of this table is to specify the program which is responsible for the layout when the window / frame  is construted or resized.
" "layout_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCOI" "object instance" "ryc_object_instance" yes "" 1004924446.09 "" "" "This is a running instance of an object on a container. This facilitates the allocation of specific attributes, links, and page numbers, etc. for the specific instance of an object.

The reason that the container_obj is included in the primary key is to ensure that we can only create links between objects in a single container, and to stop us creating links between objects in different containers at design time. The object_instance_obj however is uniqe in its own right, therefor avoiding having to specify a rolename for the container when propogating the key onto the smartlink table." "object_instance_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCPA" "page" "ryc_page" yes "" 1004924447.09 "" "" "This table defines the actual pages in a container. All containers must at least have one page, which is page 0 and is always displayed. All objects on page 0 are always displayed. If there are no other pages, then no tab folder is visualised.

Example pages could be Page 1, Page 2, Customer Details, etc." "page_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCPO" "page object" "ryc_page_object" yes "" 1004924448.09 "" "" "This table defines the object instances that appear on a page of a container and in what sequence they should be created by the layout manager. How these objects communicate on the container is defined by the supported links table." "page_object_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCSF" "smartobject field" "ryc_smartobject_field" yes "" 1004924452.09 "field_name" "" "This table contains field infromation for smartdataobjects (sdo's), smartviewers, smartbrowsers, webbrower's, webforms, etc.

Certain information is specific to certain types of objects, but is contained in a central table for performance and simplicity reasons, and to reduce the number of tables required by the repository.

The table defines the fields for a smartdataobject which are all the fields available to any objects using the smartdataobject.

When the fields are related to anything other than a smartdataobject, certain of the values only need to be specified if they differ from the default values defined in the smartdataobject fields, thereby facilitating the override of default values per instance.

Holding this information in the repository removes the dependany on the Progress system tables (underscore tables) and also allows us to add extra information required by the repository. We provide import tables to automatically create a lot of this information directly from existing objects, and wizards on the smartdataobject to populate the data for new objects.



" "smartobject_field_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCSL" "supported link" "ryc_supported_link" yes "" 1004924454.09 "" "" "This table defines the supported smartlinks for the various type of smartobjects, and whether the link can be a source, target, or both.

User defined links should not be set-up in this table. This table is purely to ensure that when linking objects on containers, only valid system links are used, plus user defined links. It is merely a developer aid.

Not all types of smartobjects support links, in which case there will be no entries in this table for them." "supported_link_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCSM" "smartlink" "ryc_smartlink" yes "" 1004924449.09 "link_name" "" "This table defines the actual smartlinks between objects on a container, to facilitate object communication. The link name may be user defined, or automatically copied from the smartlink type for system supported links.

If the source object instance is not specified, then the source s assumed to be the container. Likewise if the target object instance is not specified, then the target is assumed to be the container.

Example links would be a tableio link between a smartbrowser and a smarttoolbar, a record link between a smartbrowser and a smartviewer, etc." "smartlink_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCSO" "smartobject" "ryc_smartobject" yes "" 1004924451.09 "" "" "This entity represents every smartobject known to the repository, whether static or dynamic.

Relationships exist to various child tables; however the existence of data in these child tables corresponding to this particular smartobject is dictated by the smartobject type - e.g. only Toolbar smartobjects may have toolbar group data.

Some smartobjects are visualisations of data provided by a smartdataobject.  This is represented by the cyclic relationship ""provides data for"".

NOTE: Every ICF object will be automatically created in this table to make it easy to use a mixture of static and dynamic objects onto static or dynamic containers. The creation of these records should therefore be done by the appropriate wizards, etc.

NOTE2: We have turned off the delete trigger RI to prevent an object being deleted if it is on a container somewhere - to allow our imports and assignments of the data in the versioning system to work. Therefore, this RI must be manually coded wherever it is possible to delete a smartobject, to ensure smartobjects that exist on containers are not inadvertantly deleted.

NOTE3: We turned off the automatic delete cascade of smartobject attributes as it was also deleting attributes for instances of the smartobject when we did not want it to. Added a specific delete trigger customisation that rather joined on the primary_smartobject_obj in the attribute table when deleting attributes, to ensure only attributes for the smartobject were deleted, not also instance attributes." "smartobject_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCST" "smartlink type" "ryc_smartlink_type" yes "" 1004924450.09 "link_name" "" "This table defines the supported smart links available for linking objects on containers for object communication purposes.

Example links include page, container, update, commit, tableio, etc.

The main purpose of this table is to provide a valid list of smart links to choose from when building generic containers. Additional user defined smart links may be implemented by defining a user defined link.

The actual link name will be cascaded down onto the smartlink table where this is not a user defined link.

The supported link table will be used to highlight which are the expected links between any two smartobjects.
" "smartlink_type_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCSU" "subscribe" "ryc_subscribe" yes "" 1004924453.09 "" "" "This is a generic table that facilitates any object subscribing to events across links and running internal procedures to perform some action as a result of the event.

Its primary use would be to subscribe frames or containers to system events." "subscribe_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCUE" "ui event" "ryc_ui_event" yes "" 1007600043.08 "event_name" "" "This entity stores information about UI events for a smartobject. It works very similar to the ryc_attribute_value table in that UI events can be associated with object types, smartobjects, and smartobject instances.

Where the event is associated with an object type or a smartobject, then the event will reflect a default action. where the event is associated with an instance of a smartobject, then the action will reflect an actual action.

When creating entries in this table for events associated with an object type, then the smart object and instance will be 0.

When creating entries in the table for a smartobject, we will also populate the object type field to avoid having 0 in the key. Likewise when creating events for an object instance, we will populate the object type and the smartobject. This ensures effective use of the alternate keys.

Note: We must be careful when looking for events associated with an object type to ensure we look for the specific object type and 0 values for the smartobject and instance fields.

Where events are defined for object types and smartobjects, these values will be cascaded down to actual smartobject instances for performance reasons. Any future modifications of these values will also be cascaded down to all instances where the inherrited_value is set to YES, therefore ensuring we do not overwrite manual changes made at an instance level.
" "ui_event_obj" yes "ui_event_obj" 4 "_" no yes yes "ICFDB" "" "" ""
"RYCUT" "ui trigger" "ryc_ui_trigger" yes "" 1004924455.09 "ui_trigger_name" "" "The supported Progress UI events, e.g. choose, value-changed, etc." "ui_trigger_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCVT" "valid ui trigger" "ryc_valid_ui_trigger" yes "" 1004924456.09 "" "" "This table defines the valid triggers supported for each widget type, e.g. a button may have a choose UI trigger. This is used to filter down the available UI triggers when defining custom UI triggers - therefore avoiding runtime errors." "valid_ui_trigger_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYCWT" "widget type" "ryc_widget_type" yes "" 1004924457.09 "widget_type_name" "" "This table defines the supported widget types, e.g. frame, button, fill-in, editor, radio-set, menu-item, etc." "widget_type_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYMDV" "data version" "rym_data_version" yes "" 1004924458.09 "" "" "This table facilitates the generic storage of data version numbers without having to add a specific version number field to any tables that require version control.

This will definitely be used in the context of versioning smartobjects, but may also be used to record a version number for any data, e.g. menu items, help, etc.

The update of this table will be automated by the version control procedures if they are being used to control maintenance of the data.

This information must be made available generically to a help about window in the context of smartobject versioning.

The version number is the version number as at the time written by the versioning procedures. The data may have been subsequently changed by the user outside of the version control procedures, which is a situation we cannot generically hande.

" "data_version_obj" yes "" 4 "_" no no no "icfdb" "" "" ""
"RYMFP" "wizard fold page" "rym_wizard_fold_page" yes "" 1004924462.09 "sdo_object_name" "" "This table defines the pages of the folder window, the objects that should appear on the page and attributes about the page itself.

How the objects are linked and organised on the page will be defaulted according to rules for a standard dynamic folder window." "wizard_fold_page_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYMLF" "lookup field" "rym_lookup_field" yes "" 1004924459.09 "specific_object_name" "" "This table defines fields that have smartdatafields linked to them.

If the smartdatafield is the special case of a dynamic lookup, then the majority of the fields define the instance attributes for the dynamic lookup.

The lookup can be specific to an object, or whereever a specific field occurs in any object.

This table is used by dynamic viewers to apply smartdatafields.
" "lookup_field_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYMWB" "wizard brow" "rym_wizard_brow" yes "" 1004924460.09 "sdo_name" "" "This table captures wizard responses for the creation / modification of a standard ICF Dynamic Browser object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Browser which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
" "wizard_brow_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYMWF" "wizard fold" "rym_wizard_fold" yes "" 1004924461.09 "object_description" "" "This table captures wizard responses for the creation / modification of a standard ICF Dynamic Folder Window object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Folder Window which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
" "wizard_fold_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYMWM" "wizard menc" "rym_wizard_menc" yes "" 1004924463.09 "object_description" "" "This table captures wizard responses for the creation / modification of a standard ICF Dynamic Menu Controller object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Menu Controller which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
" "wizard_menc_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYMWO" "wizard objc" "rym_wizard_objc" yes "" 1004924464.09 "browser_name" "" "This table captures wizard responses for the creation / modification of a standard ICF Dynamic Object Controller object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Object Controller which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
" "wizard_objc_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
"RYMWT" "wizard tree" "rym_wizard_tree" yes "" 1007600054.08 "object_description" "" "This table captures wizard responses for the creation / modification of a standard ICF Dynamic TreeView Controller object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF TreeView Controller which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
" "wizard_tree_obj" yes "wizard_tree_obj" 4 "_" no yes yes "ICFDB" "" "" ""
"RYMWV" "wizard view" "rym_wizard_view" yes "" 1004924465.09 "sdo_name" "" "This table captures wizard responses for the creation / modification of a standard ICF Dynamic Viewer object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF Viewer which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
" "wizard_view_obj" yes "" 4 "_" no yes yes "icfdb" "" "" ""
.
PSC
filename=gsc_entity_mnemonic
records=0000000000140
ldbname=ICFDB
timestamp=2002/02/23-13:24:31
numformat=44,46
dateformat=mdy-1950
map=NO-MAP
cpstream=ISO8859-1
.
0000101031
