"GSCCP" "custom procedure" "gsc_custom_procedure" yes "" 41 "custom_procedure_description" "" "This table is contained in Dynamics for backward compatibility and will likely be dropped at a later stage. It will be replaced with flows and events when these are fully implemented.

The purpose of this table is to provide a mechanism to define alternate procedures for custom specific business logic.

This table contains a list of all the system supported procedures that satisfy these business rules, categorised by entity and procedure type. A number of variations for each process may exist - the procedure to use in each case must be selected from this list.

The programs that these procedures exist in will run persistently when required." "custom_procedure_obj" yes "procedure_name" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCDC" "default code" "gsc_default_code" yes "" 1004947239.09 "field_name" "" "This table makes provision for any number of parameters or system defaults that need be specified to the system, without neccessitating structural database changes.

How these parameters / defaults are used needs to be hard coded into the application.

These records can be grouped into sets under gsc_default_set, to facilitate different parameter / defaults sets. Again, the selection of a default set would be coded into the application.

An example would be different parameter sets for warehouse control, different controls per administration group etc." "default_code_obj" yes "default_set_code,owning_entity_mnemonic,field_name,effective_date" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCDD" "deploy dataset" "gsc_deploy_dataset" yes "" 1004927719.09 "dataset_description" "" "This table defines the sets of data that need to be deployed to end-user sites and migrated to different workspace databases. Usually it is static data that needs to be deployed. This table with its child table gsc_dataset_entity identify which data must be deployed as a set, i.e. has dependancies. For example, in order to deploy menu items, objects on the menu item would also need to be deployed.

These tables also define the dataset for deployment of logical objects managed by the scm tool, e.g. the ryc_smartobject and related tables.

To deploy and load the data, xml files will be generated for the dataset.

The dataset must always have a main table that is being deployed, plus all related tables that need to be deployed with it, together with appropriate join information.

Example datasets could be for SmartObjects, menus, objects, etc. It is likely that a seperate dataset will be defined for most data tables that need to be deployed, but that these datasets will include a parent dataset that includes this dataset.

When automatically generating triggers from ERWin an entity-level UDP (DeployData) is used to indicate whether trigger code should be generated for the static tables to support data deployment. A flag also exists in the entity mnemonic table called deploy_data for the same purpose.

For customer sites that receive a dataset deployment, the last deployment loaded for this dataset is record here. This helps identify at what version the current static data is for a particular database.

Customers should not modify or deploy from datasets sent by suppliers. The customer can however create their own datasets containing the same tables and deploy from these datasets. As a dataset deployment includes an xml file registered as part of the deployment, the customer can simply utilise this xml file for their database and any subsequent databases and sites they wish to pass the data on to." "deploy_dataset_obj" yes "dataset_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCDE" "dataset entity" "gsc_dataset_entity" yes "" 1004927718.09 "" "" "This table contains a complete list of tables that need to be deployed with the  dataset.

One of the tables in the dataset must be marked as primary, i.e. the main table in the dataset. The join information between the tables must also be specified.

The data in this table can be filtered using the filter where clause." "dataset_entity_obj" yes "deploy_dataset_obj,entity_sequence" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCDM" "delivery method" "gsc_delivery_method" yes "" 1004924364.09 "delivery_method_description" "" "The supported methods of delivery, e.g. by hand, post, email, collection, etc." "delivery_method_obj" yes "delivery_method_tla" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCDP" "deploy package" "gsc_deploy_package" yes "" 4618.24 "package_description" "" "This table facilitates defining groups of datasets that should be deployed together as a single package. This enables users to ensure they send all related datasets inclduing related / dependant data that has also changed." "deploy_package_obj" yes "package_code" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSCDS" "default set" "gsc_default_set" yes "" 1004924362.09 "default_set_description" "" "This table is used to associate a set of parameters / defaults i.e. a set of gsc_default_code records.

For example, there could be a general set of defaults applicable to the system in general, and other sets of defaults to be used in certain circumstances e.g. for a specific department.

The way these sets are used must be hard coded into the application." "default_set_obj" yes "default_set_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCDT" "document type" "gsc_document_type" yes "" 1004924365.09 "document_type_description" "" "The document types supported by the system. Certain document types will be hard coded as they form an integral part of the application, e.g. membership cards, etc.

Each document type will have one or more document formats associated with a customised formatting procedure.

A document type should be set up for any outgoing documents.

We need to know the document_type_tla for system owned document types as this will be used in any print_option_tlas fields to determine where certain data should be printed.

" "document_type_obj" yes "document_type_tla" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCDU" "default set usage" "gsc_default_set_usage" yes "" 1004924363.09 "" "" "This table associates default sets with objects in the application.

For example, in property administration, a default set could be for a specific administration company. In medical aid, a default set could be for a specific scheme option, employer group etc." "default_set_usage_obj" yes "default_set_code,owning_entity_mnemonic,owning_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSCED" "entity display field" "gsc_entity_display_field" yes "" 1005079469.09 "display_field_name" "" "This table defines the fields for a table that should be used when building generic objects for it, e.g. a dynamic browser.

It identifies the fields that should be used, the sequence of the fields, plus allows the label and format of the fields to be overridden.

This is actually used in the generic data security used by the framework. 

If no entries exist in this table, then all the fields other than any object fields will be used, in the standard field order as defined in the database.

This table should initially be populated automatically from the metaschema but may then be modified accordingly.

This table does not support joined fields.
" "entity_display_field_obj" yes "entity_mnemonic,display_field_name" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCEM" "entity mnemonic" "gsc_entity_mnemonic" yes "" 1004924406.09 "entity_mnemonic" "" "This table stores all the hard coded entity mnemonics allocated to every table in the application. It defines a meaningful short code and identifies the table name for each table.

It also defines generic information about the entity used when generating dynamic or generic objects based on the table, auto generating triggers, etc." "entity_mnemonic_obj" yes "entity_mnemonic" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCEP" "entity mnemonic procedure" "gsc_entity_mnemonic_procedure" yes "" 1004924366.09 "" "" "This table contains pointers to procedures which may be automatically run by the system before and after table create, write and delete triggers.

The procedures would exist under a single category type with 6 category groups:
Before create
After create
Before write
After write
Before delete
After delete." "entity_mnemonic_procedure_obj" yes "custom_procedure_obj,owning_entity_mnemonic" 4 "_" ? yes yes "ICFDB" "" "" "" yes
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
" "error_obj" yes "error_group,error_number,language_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCGC" "global control" "gsc_global_control" yes "" 1004924367.09 "" "" "This table defines system wide defaults. It contains a single record within which to hold the current system defaults.
" "global_control_obj" yes "global_control_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSCGD" "global default" "gsc_global_default" yes "" 1004924368.09 "" "" "This table contains global default values across the entire application. It differes from the parameter file in that the parameter file is specific to a user, whereas entries in this table are system wide.

Standard entries exist in the gsc_global_control table. This table facilitates the generic addition of other defaults without the need for database change. The entries in this table will be system owned by ther nature, and the only fields that may change are the owning_obj and the default_value. The changing of any of these values will create a new record for the owning_entity_mnemonic and default_type, efffective as of the new date with the new values.

Entries may not therefore be deleted from this table, other than by a system administrator." "global_default_obj" yes "owning_entity_mnemonic,owning_obj,default_type,effective_date" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSCIA" "instance attribute" "gsc_instance_attribute" yes "" 1004924408.09 "attribute_description" "" "This table contains instance attributes used in the application. Instance attributes change the behaviour of generic objects. For example, a generic object could be developed that behaved differently in a creditors and debtors system. An instance attribute of creditor or debtor could be posted to the program when run to determine its instance specific functionality.

The instance attribute will be posted to the program either via the menu option the program was run from, as setup in the menu option, or hard coded in a program if the program was run from a button, etc.

For this reason, certain instance attributes will be system owned and cannot be maintained / deleted by users.

When security structures e.g. field security are setup, they may be defined globally, for a specific product, product module or down to individual program level. The instance attribute is a level below the program level that permits security settings per instance of a program.

Instance attributes will also be used for reporting to allow reports to be printed direct from menu options. The instance attribute code must map to the report_procedure_name in the report_definition table. Whenever a report definition is created, an instance attribute should automatically be created to facilitate this functionality.

" "instance_attribute_obj" yes "attribute_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCIC" "item category" "gsc_item_category" yes "" 1007600146.08 "item_category_description" "" "This table is used to categorize items into common groups. Typical groups may be ADM Navigation, ADM TableIO or  ADM Menu . Categories may also be used to group items into module specific areas." "item_category_obj" yes "item_category_label" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCLG" "language" "gsc_language" yes "" 1004924369.09 "language_name" "" "The languages supported by the system." "language_obj" yes "language_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCLS" "gsc_logical_service" "gsc_logical_service" no "" 1004924409.09 "logical_service_description" "" "This table defines the logical services available to the application.

A logical service is a separate process running either locally or remotely that requires connection parameters to establish communication between the client and the service. 

Logical service names are unique so that connection to the service can be completely abstracted from the developer. 

The physical service will determine the actual connection parameters.

Which physical service is used is determined by combining the session type with the logical service.

Logical services for appserver service types would in fact be appserver partition names. Logical services for database connection service types would be the logical database name.

This table supports the registration of services and whether they are connected at start of a session is controlled by the connect_at_startup flag. This would typically be set to YES unless the service type is a webservice, in which case it would be NO typically due to the potential slow connection performance of webservices.

" "logical_service_obj" yes "logical_service_code" 0 "" ? yes yes "ICFDB" "" "" "" yes
"GSCLT" "language text" "gsc_language_text" yes "" 54 "physical_file_name" "" "Totally generic text file for all supported languages. Text's may be associated with another entity (via owning_obj) or may be simply generic text of a certain type. Numbers enclosed in {} are for parameter substitution.
E.g. Scheme option names, transaction narrations, valid people titles, etc." "language_text_obj" yes "category_obj,owning_obj,language_obj,text_tla" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCMM" "multi media type" "gsc_multi_media_type" yes "" 1004924370.09 "multi_media_type_description" "" "This table contains information related to different types of multi media files." "multi_media_type_obj" yes "multi_media_type_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCMT" "manager type" "gsc_manager_type" yes "" 1004924410.09 "manager_type_name" "" "This table contains the definition of the standard manager types that are used in the framework.

A predefined set of manager types will exist in this table that support the framework functionality. Only managers that directly affect the core functionality of the framework need to be defined as manager types.

For example, without a session manager we cannot start any other code, without a security manager we cannot do user authentication, etc.

The physical procedures to run for this manager type are defined in this tables and two standard ones are supported;

The bound manager object should be run for sessions that have a database connection, i.e. have a service type of database connection as one of the session services. This manager therefore requires a database connection and communicates directly with schema tables.

The unbound manager object should be run for sessions that do not have a database connection, i.e. do not have a service type of database connection as one of the session services. This manager therefore does not require a database connection and communicates indirectly with schema tables via the bound manager object running server side in a session with a database connection.

In order to support overrides of standard manager functionality, the super procedure attribute can be used against the manager object to define a super procedure stack of override functionality. It would point at a specific procedure to add as a super procedure, which in turn could have a super procedure, etc.

The bound and unbound manager fields may need to be customized to point at the last procedure in the super procedure stack, so these fields need to be defined as fields that do not get overridden by new deployments to ensure that the customizations do not get lost. This is defined in the axclude fields field of the gsc_dataset_entity table.

The manager objects specified here are always started for any session type that includes this manager type as a required manager type, via the gsm_required_manager table. We therefore do not support the ability to start different manager objects for different session types. If this is required, then different manager types must be defined." "manager_type_obj" yes "manager_type_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCNA" "nationality" "gsc_nationality" yes "" 1004924371.09 "nationality_name" "" "" "nationality_obj" yes "nationality_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCOT" "object type" "gsc_object_type" yes "" 1004924413.09 "object_type_description" "" "This table defines the types of programs supported. A record will need to exist for the various support templates, e.g. ""Object Controller"", ""Menu Controller"", ""SmartFolder"", smartbrowser, smartviewer, smartdataobject, etc.

When objects are created, they must be assigned an object type.

The object type is used as a grouping mechanism for security, to allow restrictions to be created for certain types of objects, rather than having to setup security for every object.

A recursive join exists for the object type to facilitate definition of object type hierarchies (class hieararchies). This is then useful for attribute inheritance at multiple levels of object type.

For example, an object type could be defined for a fill-in, then a child of this may be an integer fill-in, then a child of this may be an object id, etc.

the extends object type means the inherit from object type.
" "object_type_obj" yes "object_type_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCPC" "profile code" "gsc_profile_code" yes "" 1004924373.09 "profile_code" "" "This table defines the codes that exist for each profile type, and the structure of the key / data value fields when this code is allocated against a user in the gsm_profile_data table.

An example profile type would be filter settings, and example profile codes for filter settings would be filter from values, filter to values, filtering enabled, filter field names, etc." "profile_code_obj" yes "profile_type_obj,profile_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCPD" "package dataset" "gsc_package_dataset" yes "" 4621.24 "" "" "This table defines the datasets that should be included with a package. A dataset may be included in multiple packages." "package_dataset_obj" yes "deploy_dataset_obj,deploy_package_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSCPF" "profile type" "gsc_profile_type" yes "" 1004924374.09 "profile_type_description" "" "This table defines the types of profile codes supported for allocation to users.

Records will exist for any type of profile information stored against a user between sessions. Examples include browser filter settings, report filter settings, Toolbar cusomisation settings, window positions and sizes, system wide settings such as tooltips on/off, etc.




" "profile_type_obj" yes "profile_type_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCPM" "product module" "gsc_product_module" yes "" 1004924415.09 "product_module_description" "" "This table contains information about the installed product modules with appropriate license details.

A recursive join has been added to support product module hierarchies." "product_module_obj" yes "product_module_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCPR" "product" "gsc_product" yes "" 1004924414.09 "product_description" "" "This table contains information about the installed products with appropriate license details." "product_obj" yes "product_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCSC" "security control" "gsc_security_control" yes "" 1004924375.09 "default_help_filename" "" "Extra control information pertinent to security settings. This table will actually only contain a single record." "security_control_obj" yes "security_control_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSCSM" "scm tool" "gsc_scm_tool" yes "" 3000049705.09 "scm_tool_description" "" "This table defines possible software configuration management tools that could be integrated with Dynamics. The tool currently in use is identified via the gsc_security_control table.

An example of an integrated SCM tool is Roundtable (RTB).

The primary purpose of this table is to link together xref information between the Dynamics repository and the SCM tool for data such as product modules, object types, etc. as specified in the gsm_scm_xref table.

" "scm_tool_obj" yes "scm_tool_code" 4 "_" ? no no "ICFDB" "" "" "" no
"GSCSN" "next sequence" "gsc_next_sequence" yes "" 1004924372.09 "" "" "This table is used to allocate sequence numbers where it is possible that multiple sequence numbers may be requested by multiple transactions simultaneously - it is intended to avoid deadly embrace record locks.





When a gsc_sequence is created / updated with multi_transaction set to YES, number_of_sequences records are created in this table starting from gsc-sequence.next_value.





When a sequence number is requested, the first record in this table for the gsc_sequence is found, saved and deleted. At the same time, a new gsc_next_sequence record is tagged on the end i.e. with the sequence number just found plus number_of_sequences." "next_sequence_obj" yes "sequence_obj,next_sequence_value" 4 "_" ? no no "ICFDB" "" "" "" no
"GSCSP" "session property" "gsc_session_property" yes "" 1004924418.09 "session_property_description" "" "This table contains the list of valid properties that may be specified in the ""properties"" node of the ICF configuration file (ICFCONFIG.XML).

These property values can be set and retrieved using calls to the Session Manager. They can thus be used to alter the way that the session performs depending on the session type.
" "session_property_obj" yes "session_property_name" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCSQ" "sequence" "gsc_sequence" yes "" 1004924376.09 "sequence_description" "" "This is a generic sequence number / format table. All entries in this table will be system owned by their nature.





When a sequence number is required to be generated, it will be done at the end of the update as part of the transaction. This table is a potential bottle neck and so locks should be kept to an absolute minimum, i.e. no locks during user interaction.





If the sequence number is to be automatically generated, then there can be no holes in the sequence numbers, which is why a Progress sequence will not be used.





Example uses for this table would be for the automatic generation of document numbers, transaction references, etc." "sequence_obj" yes "company_organisation_obj,owning_entity_mnemonic,sequence_tla" 4 "_" ? no yes "ICFDB" "" "" "" no
"GSCST" "service type" "gsc_service_type" yes "" 1004924417.09 "service_type_description" "" "This entity describes the different types of services available to applications and provides the management procedures for the different types of connections.

To illustrate, database services, AppServer services and JMS partitions are all different service types. The Database and AppServer services are system owned.

The maintenance object defines the datafield object used to maintain the physical connection parameter attribute on the physical service table. For example, if this is a service type for database connections, then the datafield may allow the specifiction of -S -N and -H prompts independantly and then put the result as 1 field into the connection parameter.

The management object is the api procedure that is responsible for making the physical connections to the service.

In the case of an appserver partition, the default logical service could point at the default logical appserver partition to use.

" "service_type_obj" yes "service_type_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSCTG" "data tag" "gsc_data_tag" yes "" 2496.38 "data_tag_description" "" "This table defines generic tags that may be assigned to data via the gsm_tagged_data table.

The core Dynamics framework utilises the tag mechanism to identify which data belongs to and is shipped with the core product using a tag ""ry-own"", e.g. to identify which object classes and related data belong to the core Dynamics product and should not be modified by users of the framework.

Applications could use the tag mechanism to tag data that belongs to specific applications, or for any other generic purpose.

The data in this table would need to be deployed as part of Dynamics and would typically only be relevant at design and deployment time rather than used as part of the runtime application. For example, rules could be applied to tagged data to prevent unauthorized or accidental modification of the data as design time, and tags could be used to help identify what data to deploy as part of an application.

A generic mechanism is required in the framework to be able to easily attach data tags to data, typically from a browse view but also from within viewers when maintaining a specific record. Additionally, a central tool is required to maintain and manage multiple tags together.

API's also need to be provided to make it easy to identify and work with tagged data as necessary.

Session / configuration data will be required to configure how to operate on specific tags for specific purposes, e.g. to disable certain data due to ownership rules." "data_tag_obj" yes "data_tag_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMAV" "profile alpha value" "gsm_profile_alpha_value" yes "" 1004924388.09 "description" "" "List of valid values / ranges for an alpha profile" "profile_alpha_value_obj" yes "profile_obj,profile_sequence" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMCA" "category" "gsm_category" yes "" 1004924377.09 "category_description" "" "A multi-purpose grouping mechanism for generic entities. Certain categories may be system owned / generated and may not be deleted. These are usually hard coded into programs.

Additionally, some categories may not be associated with another generic entity. These are used to store hard coded valid value lists, lookup lists, etc. Where ever we have made use of hard coded mnemonics within the application, their usage and description will be defined in this table. 

Refer to the ""Generic Table Usage"" document for a detailed description and sample instance data." "category_obj" yes "related_entity_mnemonic,category_type,category_group,category_subgroup" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMCL" "control code" "gsm_control_code" yes "" 1004924378.09 "control_short_description" "" "This is a generic table for holding device control codes. The category is used to define what the code is for, and the owning_obj is optionally to define the device the code relates to. If the owning_obj is left as 0, then it applies to all devices.

An example use is in a point of sale system where codes must be sent to a pole for various reasons, e.g. to reset the poll, to make the message scroll, etc. Different categories would be defined for each action. The owning_entity_mnemonic on the category would determine which table the owning_obj related to. This will usually be some sort of application specific device table.
" "control_code_obj" yes "category_obj,owning_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMCM" "comment" "gsm_comment" yes "" 87 "comment_description" "" "Generic comment linked to any entity." "comment_obj" yes "category_obj,owning_reference,comment_obj,owning_entity_mnemonic" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMCR" "currency" "gsm_currency" yes "" 1004924380.09 "currency_description" "" "This table contains all the currency codes and their symbol references that are available to the system" "currency_obj" yes "currency_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMCY" "country" "gsm_country" yes "" 1004924379.09 "country_name" "" "Supported countries, e.g. USA = United States of America, SA = South Africa, UK = United Kingdom" "country_obj" yes "country_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMDR" "default report format" "gsm_default_report_format" yes "" 1004924381.09 "" "" "This table provides an override mechanism for default report layouts. For example, specific organisations or people can specify a different default report format for a specific document type.

This would typically be used for login company organisations, where for each of the different login companies, a different statement print layout or cheque layout , etc. could be used by default." "default_report_format_obj" yes "owning_entity_mnemonic,owning_obj,document_type_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMEF" "entity field" "gsm_entity_field" yes "" 1004924382.09 "entity_field_description" "" "This table facilitates securing any application specific or generic data against any entity.

For example, if there is a requirement to secure access to specific companies, then the company entity, with the company code field could be set-up in this table. The valid values could then be setup in the entity field values table, and users allocated access to the specific values." "entity_field_obj" yes "owning_entity_mnemonic,entity_field_name" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMEV" "entity field value" "gsm_entity_field_value" yes "" 1004924383.09 "" "" "The valid values for the entity field, e.g. company codes." "entity_field_value_obj" yes "entity_field_value_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMEX" "external xref" "gsm_external_xref" yes "" 1004924384.09 "external_description" "" "This table defines generic cross reference information to details in external tables.

For example, an organisation whose accounts are held in this database, may have other account codes in an external database where these account codes originated from. This table could be used to define which internal accounts point to which external accounts for xref and reporting purposes. In this example, the fields would be setup as follows:
related entity = The gsm_organisation table in this database
related object = Specific organisations
Internal entity = The gsm_account table in this database
internal object = specific account codes

If an external table is available, then the external entity and object can be defined, otherwise the external details can be keyed directly into this table.
" "external_xref_obj" yes "related_entity_mnemonic,related_owning_obj,internal_entity_mnemonic,internal_owning_obj,external_xref_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMFD" "filter data" "gsm_filter_data" yes "" 3000049736.09 "expression_field_name" "" "This table defines the filters that are applicable to a filter set, and a filter set can have many filters that apply. 

By default, the include flag will be set to NO, indicating the specified criteria must be excluded from the result set. If the include flag is set to YES, then this will be treated as an override condition to re-include specific data. This will work by building up a bracketed where clause for all the exclusions, using the AND operator, and then outside this bracket, performing an OR operator for any data that must be re-included - allowing overrides for specific data. Clearly this must be used sparingly to avoid potential performance problems.
The table can be read as meaning to exclude all specified data except the data that is specifically included back in. For example, exclude all objects in all repository modules, except for objects where the template flag is true or the object type is a toolbar.

If a specific record is to be specified, then the owning_reference field will point at the object id for that table. For example, if the owning_entity_mnemonic is GSCPM for gsc_product_module, then the owning_reference will point to a specific product module product_module_obj.

Alternatively a more generic expression can be specified, by supplying a fieldname, e.g. object_filename, an operator, e.g. BEGINS, and a value, e.g. ""standardtoolbar"".

It is not possible to specify a generic expression and a specific record, one or the other must be specified in a single filter data record.

This table provides significant flexibility in the specification of what data to filter. It will be possible for example to specify a list of product modules to exclude, but to re-include specific objects from some of the excluded product modules." "filter_data_obj" yes "" 4 "_" ? no no "ICFDB" "" "" "" no
"GSMFF" "field" "gsm_field" yes "" 103 "field_description" "" "Fields that require secured access in the software. Not many fields required security, but those that do should be defined in this table. Users can only be given restricted access to fields specified in this table.

If a user is given restricted access to a field specified in this table, then the access granted to the user may be view only, hidden, or update.

For field security to be activated, entries must be created in the security structure table, as it is this table that is allocated to users, and allows the field security to be restricted or different in various parts of the application.

Usually developers will create appropriate fields, and users may then assign them to certain parts of the application via the security structure table.
" "field_obj" yes "field_name" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMFI" "filter set" "gsm_filter_set" yes "" 3000049748.09 "filter_set_description" "" "This table is a grouping mechanism for numerous filter settings that make up a single filter definition. A standard filter set will be defined called ""Repository"" that contains all the filter records required to be able to filter out repository data. Filter sets can then be modified and extended to filter out additional data or include data that was previously excluded.

We use user profile codes to assign a filter set to a user, rather than setting the flag, display repository data yes or no. If no filter set is allocated to a user, then no filters apply. Only a single filter set may be applied at any one time. 
" "filter_set_obj" yes "filter_set_code" 4 "_" ? no no "ICFDB" "" "" "" no
"GSMFS" "flow step" "gsm_flow_step" yes "" 1004924420.09 "" "" "This table contains the steps that have to be followed to complete a flow.

Each step may involve the running of an object, the running of an internal procedure within an object, or the execution of another complete flow.

The flow steps may be customised for specific login organisations so that entire steps may be replaced with custom specific code. 

The standard flow steps will be specified with a 0 login company. Within a single flow the login company can either be 0 or a specific company. When running each step it will first check for a customisation for the login company and if not found will just run the standard step. 

If a customisation is found, this may either be an additional step in which case the custom step will be run first, or else it will be a complete replacement of the standard step.

It is also possible to add custom steps that do not have any standard code at all, i.e. no step with a 0 login company exists. This facilitates adding customisations after the standard behaviour.





 and so setting up company specific steps would involve copying the default flow steps to a specific login company in full and then customising the specific steps as required. If the standard flow is modified, customised steps would also need to be manually modified as appropriate.
" "flow_step_obj" yes "flow_obj,flow_step_order,login_company_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMFW" "flow" "gsm_flow" yes "" 1004924419.09 "flow_description" "" "A flow is a set of steps that have to be performed in a certain order to result in certain desired behavior. 

This table groups the steps that have to be performed.

af/sup2/afrun2.i takes a parameter (&FLOW) which maps to one of these flows and then executes the steps that make up the flow.

A flow must ultimately map to a single transaction and therefore must be executed on a single physical partition or service.

Example flows may be shipOrder, completeOrder, postTransaction, etc.
" "flow_obj" yes "flow_name" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMGA" "group allocation" "gsm_group_allocation" yes "" 3000049755.09 "" "" "This table defines which groups a user belongs to - for security purposes. It is also possible to set up groups that belong to groups. If the login company is specified, this indicates that security for this group only applies when logged into the specified company.

" "group_allocation_obj" yes "group_allocation_obj" 4 "_" ? no no "ICFDB" "" "" "" no
"GSMHE" "help" "gsm_help" yes "" 1004924421.09 "help_filename" "" "This table defines help contexts for containers, objects on containers, and fields on obejcts if required.

When context sensitive help is requested, the context and help file will be retrieved from this file if available.

Help may be specified in multiple languages if required.

An entry in this table for a specific language but no container, object or field specified will override the standard help file used systemwide for the specified language from gsc_security_control." "help_obj" yes "help_container_filename,help_object_filename,help_fieldname" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMIT" "menu structure item" "gsm_menu_structure_item" yes "" 1007600157.08 "" "" "This table associates menu items with menu structures. A menu structure may contain many menu items and a menu item can be used by many menu structures.

This tables also defines the sequence that menu items appear within a menu structure.
" "menu_structure_item_obj" yes "menu_structure_obj,menu_item_sequence" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMLG" "login company" "gsm_login_company" yes "" 1004924385.09 "login_company_short_name" "" "This framework table defines login companies (organisations) and is used to provide a list of valid companies the user may log into at runtime.

It is intended that this table will link into an external application database where additional details will be stored for the login company, e.g. address and contact information. The code or the object field could be used as the xref into the external application database.

The table is required in the framework to facilitate the generic set-up of framework data specific to login companies, e.g. security allocations, automatic reference numbers, etc.

The existence of a login company in the framework supports the concept of holding multiple company application data in a single database as apposed to having separate databases for each company. Application databases would further have to link to this table or a corresponding table in their database design to filter appropriate data for each login company.

We only hold on this table the minimum details as required by the framework. Applications that also have an organisation table will need to replicate modifications from their full organisation table into this table in order to simplify and syncrhonise maintenance of this data.
" "login_company_obj" yes "login_company_code" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMMI" "menu item" "gsm_menu_item" yes "" 124 "menu_item_description" "" "This table defines the dynamic menu items that may belong to either a menu structure or a toolbar.  An 'item' can be visualized as a menu item in a menubar (or submenu, ruler) , or a control (button, combo box) in a toolbar. A menu item may launch an actual program, publish an event to an object, or set a property.
" "menu_item_obj" yes "menu_item_reference" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMMM" "multi media" "gsm_multi_media" yes "" 1004924386.09 "multi_media_description" "" "Generic multi media file linked to any entity." "multi_media_obj" yes "multi_media_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMMS" "menu structure" "gsm_menu_structure" yes "" 1004924422.09 "menu_structure_description" "" "This table defines the dynamic menu structues available. A menu structure must belong to a product, and can optionally also be associated with a product module if required - for sorting purposes.

The menu structure code will be referenced in source code to build any dynamic menu items associated with the menu structure." "menu_structure_obj" yes "menu_structure_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMND" "node" "gsm_node" yes "" 1005103085.101 "node_description" "" "This table contains a parent-child relationship of node behaviour for the TreeView controller.

This table includes support for structured nodes. A structured node is a node where each new level is created infinitely from the same SDO, thus meaning that a node can be expanded infinite times and these nodes does not have to be set up for each level in node control.

An example of the structured node field values for setting up a structured node treeview on this table would be;

structured_node - YES
parent_node_filter - parent_node_obj = 0
parent_field - parent_node_obj
child_field -  node_obj
datatype - DECIMAL
" "node_obj" yes "node_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMNV" "profile numeric value" "gsm_profile_numeric_value" yes "" 1004924393.09 "description" "" "List of valid numeric values / ranges for a profile.

For other systems, this table is also used for determining contribution rule values e.g. for age or income ranges in conjunction with a hard coded category. The rule value used would be the numeric_value_to.
" "profile_numeric_value_obj" yes "profile_obj,profile_sequence" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMOM" "object menu structure" "gsm_object_menu_structure" yes "" 1004924423.09 "" "" "This table defines the dynamic menu structures used by the object - if applicable. Only container objects may have dynamic menu structures.

If an instance attribute is specified, then the menu structure will only be dynamically built if the instance attribute is passed in from the previous menu option.

This facilitates pulling in different dynamic menu options for a specific object based on its use, e.g. creditors, debtors, etc. having different options.

" "object_menu_structure_obj" yes "object_obj,menu_structure_obj,instance_attribute_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMPA" "profile alpha options" "gsm_profile_alpha_options" yes "" 1004924387.09 "" "" "Alpha specific details for a profile" "profile_alpha_options_obj" yes "profile_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMPD" "profile date value" "gsm_profile_date_value" yes "" 1004924390.09 "description" "" "List of valid dates / date ranges for a profile" "profile_date_value_obj" yes "profile_obj,profile_sequence" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMPF" "profile data" "gsm_profile_data" yes "" 1004924389.09 "" "" "This table is used to store profile information for specific users, e.g. browser filter settings, window positions and sizes, report filtter settings, etc.

The nature of the data key and data value fields is determined by the profile type and code.

Data can be stored permannently, or only for the current session, depending on the context_id field." "profile_data_obj" yes "user_obj,profile_type_obj,profile_code_obj,profile_data_key,context_id" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMPH" "profile history" "gsm_profile_history" yes "" 1004924391.09 "" "" "History of profiles relating to an object from the effective date onwards.

In other systems, in the case where a profile is related to contribution rule value determination, the value fields are not applicable." "profile_history_obj" yes "profile_obj,owning_obj,effective_date" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMPN" "profile numeric options" "gsm_profile_numeric_options" yes "" 1004924392.09 "" "" "Numeric specific options for a profile." "profile_numeric_options_obj" yes "profile_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMPR" "profile" "gsm_profile" yes "" 143 "profile_description" "" "Generic profiles that can be attached to any entity or may stand alone to be used as control information or lookup lists. Profiles could be utilised for user defined fields e.g. smoking and drinking habits of members.

For other systems, the modification of a profile and it's related tables must be inhibited where it exists in any s_contribution_type.rule_code_profile_objs with existing s_contribution_rules records." "profile_obj" yes "category_obj,profile_tla" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMPY" "physical service" "gsm_physical_service" yes "" 1004924424.09 "physical_service_description" "" "A physical service provides the specific connection parameters that are required to connect a physical service to a session.

The physical service is connected to a logical service and session type via the session service.

The maintenance object on the service type defines the datafield object used to maintain the physical connection parameters attribute. For example, if this is a service type for database connections, then the datafield may allow the specifiction of -S -N and -H prompts independantly and then put the result as 1 field into the connection parameters.

The management object on the service type is the api procedure that is responsible for making the physical connections to the service.
" "physical_service_obj" yes "physical_service_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMRA" "range" "gsm_range" yes "" 146 "range_description" "" "These are range structures that control what data a user may view. When allocated to a user, the ranges of permitted data will be specified.

Sample range structures could include ""Nominal Codes"", ""Cost Centres"", or ""Member Codes"", etc.

The appropriate data will be hidden from the user.

For range security to be activated, entries must be created in the security structure table, as it is this table that is allocated to users, and allows the range security to be restricted or different in various parts of the application.

Usually developers will create appropriate ranges, and users may then assign them to certain parts of the application via the security structure table.
" "range_obj" yes "range_code" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMRD" "report definition" "gsm_report_definition" yes "" 147 "report_description" "" "This table contains control and default  information about all the reports produced by the system.

Note that all reports will be created by initially extracting a delimited data file which could then be printed using any reporting tool.

This table actually defines the report extract procedure and default report options. The extract can the be printed in various formats as defined by the gsm_report_format table.

The name of the extract file(s) produced will be hard coded in the extract procedure, but will be derived from the extract procedure name. The extension will be .rpd suffixed with the date and time down to seconds for multi-user support. The actual names used will be recorded in the gst_extract_log." "report_definition_obj" yes "report_definition_reference" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMRE" "reporting tool" "gsm_reporting_tool" yes "" 1004924425.09 "reporting_tool_description" "" "This table contains information about the reporting tools available to the system. These would be:
Progress
Results
Crystal reports
Actuate
etc." "reporting_tool_obj" yes "reporting_tool_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMRF" "report format" "gsm_report_format" yes "" 149 "report_format_description" "" "Once data for a report has been extracted, it may be printed in different formats using different reporting tools.

This table defines the report procedures that may be used to format the extracted data. If printing to Crystal, the report fromat procedure is the name of the Crystal Report definition file.

The extract files to send as data to the report will be hard coded in the report extract procedure." "report_format_obj" yes "report_format_reference" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMRL" "release" "gsm_release" yes "" 3000049785.09 "" "" "This table provides a mechanism to record what versions of an object belong to a release, when used in conjunction with the child table, gst_release_version.

This table identifies an actual release, giving the release a specific reference, summary and detailed notes of the reason for the release, and details of when the release was created and by whom.

The release number will usually be an auto generated reference, using the gsc_sequence table to control the generation. The release number should contain the site number as part of the reference to indicate which site the release originated from and to avoid conflicts.

When creating the release, a gst_release_version record must be created for every gst_record_version, marking the current version number of all data as of this release.

This can then be used to determine what data needs to be deployed between releases, i.e. what data has been modified between the releases by checking for matching version numbers in the gst_release_version table.
" "release_obj" yes "release_number" 4 "_" ? no no "ICFDB" "" "" "" no
"GSMRM" "required manager" "gsm_required_manager" yes "" 1004924426.09 "" "" "This table contains a list of the manager types that are required to be started during the startup of the session and the order in which they must be started. Any manager types which need to be written to the config file must always be started first. 

The write_to_config attribute of the manager will cause this procedure name to be written to the config.xml file so that it can be started up before the session makes a connection to the runtime repository.

The framework supports a standard set of manager types that are required but specific applications may require the startup of additional manager types for performance reasons, e.g. a financial system may require a frequently referenced financial manager api to be pre-started." "required_manager_obj" yes "manager_type_obj,session_type_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMSC" "server context" "gsm_server_context" yes "" 1004924427.09 "context_name" "" "This table is a generic table to stored context information between stateless appserver connections.

The type of information that is required includes user information, security information, possibly SCM workspace and task information, web page field values, etc.

This is a child table of the context scope, gst_context_scope and could be context data scope to a session, or to a user." "server_context_obj" yes "session_obj,context_name" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMSE" "session type" "gsm_session_type" yes "" 1004924429.09 "session_type_description" "" "A session type is a namespace for grouping specific types of sessions together.

For example, a ""receipting workstation"" would be a specific session type while a ""salesman's web agent"" could be another.

Each session type is combined with a physical session type that maps to a list of known Progress 4GL run-time environments. 

Thus, ""receipting workstation"" may be mapped to a 4GL GUI client while ""salesman's web agent"" could be mapped to a WebSpeed Transaction Agent.

Thus you could create any number of session types mapping them to specific 4GL session types.

Where different managers, etc. need to be pre-started for different applications, then the different applications would be defined as new session types.

In order to run locally without appserver connections, etc. you would need to define a new session type that connects to appropriate databases and has no session service records for the appserver logical services thereby forcing them to not connect and rather simply use the session handle for code portability. Also, this new session type would define a different set of managers to run, i.e. run the server side managers locally.

We will provide a facility to change the session type on the fly (if possible).

We have a recursive join to the gsc_session_type table to support inheritance of settings across multiple session types. This will make the modification, re-use and creation of session types much simpler. The program that generates the icfconfig.xml file will simply read the extra details from the linked session types and write out an accumulated set of configuration details.

This table also holds parameter details for the session, such as whether to support failover and inactivity timeouts for sessions." "session_type_obj" yes "session_type_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMSF" "startup flow" "gsm_startup_flow" yes "" 1004924432.09 "" "" "This table defines a list of flows that have to be run at startup of the session after the management procedures have been initialized, in order to perform any specific session setup, e.g. caching of various information." "startup_flow_obj" yes "flow_obj,session_type_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMSH" "status history" "gsm_status_history" yes "" 1004924396.09 "" "" "Actual status of an object as from the effective date" "status_history_obj" yes "owning_obj,from_date,status_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMSS" "security structure" "gsm_security_structure" yes "" 1004924394.09 "" "" "The parts of the application where security restrictions are applicable to. Currently access tokens, fields, and ranges are supported. The owning_obj will refer either to a gsm_token record, a gsm_field record, or a gsm_range record.

One table is used rather than a usage table for each of the above as the fields are identical, and if another type is introduced, no major rewrites will be required as this table will automatically support it.

The security restriction may be assigned globally, in which case the product module, object and instance attribute will be 0.

Alternatively the restriction may be allocated to a product module, a specific program object, or even an insance attribute for a program.

A restriction must be assigned to this table for it to be active at all. It is entries in this table that are allocated to users.
" "security_structure_obj" yes "owning_entity_mnemonic,owning_obj,product_module_obj,object_obj,instance_attribute_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
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

The status an object is at effective from a specific date is determined by an entry in the status history table, which means the status does not need to be added to every table it is used for. However, in some cases we have linked objects directly to the status table to show the current status for performance reasons." "status_obj" yes "category_obj,status_tla" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMSV" "session service" "gsm_session_service" yes "" 1004924428.09 "" "" "The session service table defines the different physical services for each session type in order to establish the logical service.

For example, an AppServer may require a shared memory connection to the repository database whereas a client session would require a network connection to the same databases. The physical connection parameters are different for each of these. Therefore the logical service identifies the database that needs to be connected and the physical service describes the mechanism for the connection dependant on the session type.

If no session service record exists then the logical service can only run locally.
" "session_service_obj" yes "session_type_obj,logical_service_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMSX" "scm xref" "gsm_scm_xref" yes "" 3000049804.09 "" "" "This table defines the mapping between data in the Dynamics repository and an external SCM tool, with mapping being defined per SCM tool in use.

Examples of the types of data that is mapped includes object types and product modules. This facilitates the external SCM tool using different codes than those used in Dynamics. It also allows mutiple codes in Dynamics to share a common code in the external SCM tool, e.g. many product modules and object types in Dynamics could point at common modules and subtypes in an SCM tool such as Roundtable.

The scm foreign key field is the field in the external SCM tool. This is a character field for maximum portability. API's should be used to provide lookup lists for values in the external SCM tool.

Data must be set up in this table for SCM integration to function, so that it is clear what data is mapped to what. If it is a one to one mapping, then tools can be used to synchronize the data and set it up automatically.
" "scm_xref_obj" yes "owning_reference" 4 "_" ? no no "ICFDB" "" "" "" no
"GSMSY" "session type property" "gsm_session_type_property" yes "" 1004924430.09 "" "" "This table resolves the many-to-many relationship between gsc_session_property and gsm_session_type.

If a record is found in this table for a property and a session type, the value specified in that record is written to the ICF configuration file for the parameter.

If no record exists for a given property and session type, the always_used flag on the gsc_session_property table is checked. If the flag is on, the default value in the default_property_value field on the gsc_session_property table is used." "session_type_property_obj" yes "session_type_obj,session_property_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMTD" "tagged data" "gsm_tagged_data" yes "" 2503.38 "" "" "This table associates data tags as defined in the gsc_data_tag table with specific items of data, e.g. specific object types to identify that the object types belong to the core Dynamics product.

See description against table gsc_data_tag for further details on how this is intended to work.

A specific item of data may contain any number of tags for various purposes, but a specific tag may only be allocated once to a specific item of data.

As tags are generically attached to data, the schema triggers for data that may have tags attached will need to ensure that the tags are deleted when the data is deleted - like the mechanism used for generic comments and auditing." "tagged_data_obj" yes "owning_entity_mnemonic,owning_reference" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMTI" "translated menu item" "gsm_translated_menu_item" yes "" 3000003009.09 "image1_up_filename" "" "This table stores menu item translations. Fields requiring translation are duplicated from the gsm_menu_item table and translations for them stored in this table by language.

This table is only required to be referenced if the users login language does not match the source language of the menu item, otherwise the standard fields on the gsm_menu_item can be used, i.e. this table is only required if a translation is required." "translated_menu_item_obj" yes "menu_item_obj,language_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMTL" "translation" "gsm_translation" yes "" 1004924397.09 "widget_name" "" "This table containes user defined translations for the various languages for widget labels and tooltip text.

The setup of every program will first walk the widget tree and change the label / tooltip to the entry in this table according to the language selected by the user - if an entry exists.

Translations can be turned off globally using the gsc_security_control.translation_enabled flag.
" "translation_obj" yes "object_filename,widget_type,widget_name,widget_entry,language_obj,source_language_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMTM" "toolbar menu structure" "gsm_toolbar_menu_structure" yes "" 1007600089.08 "" "" "This table is used to group bands or menu structures into a complete toolbar and menubar structure." "toolbar_menu_structure_obj" yes "object_obj,menu_structure_sequence,menu_structure_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"GSMTO" "token" "gsm_token" yes "" 164 "token_description" "" "Tokens are used in the application to control access to functions the user may perform within a program via tab folder page names and button names.

Tokens may be created for any tab page names or button labels, being careful to ignore any shortcut characters and ... suffixes. The tokens must then be added to the security structure table to become active. The security structure table facilitates the token being restricted for a specific object instance, specific object, specific product module, or generically for everything.

The software will only check security providing a valid enabled token exists for the button label or tab folder page.

If a user has no tokens allocated at all, then it is assumed they have full access (providing security contol is set to full access by default). Once a user is allocated tokens, then security comes into force and the user will only be granted access for folder pages and buttons they have been granted access to (an that have restricted access set up).

Example tokens would be add, delete, modify, view, copy, page 1, page 2, etc.
" "token_obj" yes "token_code" 4 "_" ? no yes "ICFDB" "" "" "" yes
"GSMUC" "user category" "gsm_user_category" yes "" 1004924400.09 "user_category_description" "" "This table defines categories of users. It could be used for job functions, etc. It's primary use is for filtering and reporting." "user_category_obj" yes "user_category_code" 4 "_" ? yes yes "ICFDB" "" "" "" yes
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
" "user_allocation_obj" yes "user_obj,login_organisation_obj,owning_entity_mnemonic,owning_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMUS" "user" "gsm_user" yes "" 1004924398.09 "user_full_name" "" "This table defines the users who may log into the system, i.e. the users of the system.

The main user details are contained in an external security system, e.g. openstart pointed at by the external_userid field. This table defines extra user information for this system, and allows a user to be optionally associated with a person to facilitate full name, address, etc. details to be entered for a user as well as comments.

There is a logged in flag on this user record to facilitate the identification of user availability (a user is available if they are logged into this application).

The existence of this specific user table in our database also facilitates automatic referential integrity.

" "user_obj" yes "user_login_name" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSMVP" "valid object partition" "gsm_valid_object_partition" yes "" 1004924436.09 "" "" "This table defines a list of valid partitions in which a procedure can be run.

A partition is a logical AppServer Partition.

The list only contains records when the object is restricted to certain partitions. When the object may be run on any partition, there are no records in this table.

The records in this table are only applicable to appserver session types." "valid_object_partition_obj" yes "logical_service_obj,object_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTAD" "audit" "gst_audit" yes "" 186 "program_name" "" "Global audit file to record modifications to data. The audit can be turned on by defining a category of audit for an entity type. It can be turned off again simply by resetting the active flag on the category.
The audit will hold basic details on the action (create, amend, or delete), the user, date & time, the program and procedure used to perform the action, and possibly a record of the data before the update.
The audit could easily be used to keep old values of fields by defining more categories, e.g. one for each field or group of fields on an entity." "audit_obj" yes "audit_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTBT" "batch job" "gst_batch_job" yes "" 1004924401.09 "job_description" "" "A job can be run immediately or at a user selected time in which case it is stored as a batch job. A daemon will monitor this table and initiate the jobs at the selected time.

The batch_job_procedure_name may be the same as a report_procedure_name, or it may be for a separate procedure that initiates a number of separate procedures. These may or may not be report_procedure_name's.

Parameters for the batch job will be stored as per those for the report definition." "batch_job_obj" yes "batch_job_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTCS" "context scope" "gst_context_scope" yes "" 3000049853.09 "scope_name" "" "This table defines the scope of the server context data, either by session or by user.

If the context scope is for a user, then the context data in gsm_server_context will persist across sessions and will remain valid for the user until it is deleted or expires (as determined by the flag on gsc_security_control indicating after what period user context data should expire). This facilitates storing context for a user that can be re-used in new sessions, e.g. shopping cart information that can persist between web sessions. For user context scope, the session_obj will be set to 0 and a valid user_obj must be specified.

If the context scope is for a session, then the context data in the gsm_server_context table will only be valid for the duration of a single session. In this case the session_obj will be specified and the user_obj will be 0.

A name is given to the scope record to identify the scope. This is mainly useful for context scoped to a user, and can be used via APIs to retrieve specific types of scope. Where the scope name is not required or specified, it will simply be automatically set to the string value of the context_scope_obj so that it has a unique number. The scope name is only unique for active context (transaction complete is no) and once context is complete, the scope name is irrelevant and can be duplicated. This unique validation must therefore be handled in code.

When dealing with transaction data, many context scope records could exist for a single session for a single transaction, and where this is the case, the parent scope object id identifies which scope records together form the complete transaction. The record with a parent of 0 is the top parent scope. An example of where this is necessary is on the WEB when dealing with parent and child data, e.g. order and order lines as a single transaction across multiple web pages. An order may contain many order lines, and each order line will have a common set of fields but with different values in each case, so the data stored in the gsm_server_context table needs to point at a different context scope record to handle the same data fields existing in context for different records. This allows us to gather up context data across multiple web pages for multiple records, and commit the entire set of data as a single transaction.

The transaction complete flag is only set for the top parent context scope where the object id is 0, and indicates that the transaction is finished and may be tidied up by the garbage collector. The session complete flag on gst_session can override this if that is set to YES and this is session scoped context data. Additionally, the scope name must be unique for context scope where the transaction complete flag is no.
" "context_scope_obj" yes "context_scope_obj" 4 "_" ? no no "ICFDB" "" "" "" no
"GSTDF" "dataset file" "gst_dataset_file" yes "" 4623.24 "ado_filename" "" "This table keeps a record of ADO files generated for a dataset. A single dataset may be generated out to multiple ADO files.

The purpose of this table is to record the date and time this dataset ADO file was last loaded into the current repository. Checks will be made against the file date on disk to see whether a new files has been downloaded from POSSE and needs to be updated into the local repository.

If an ADO file is included as part of a package, this table records the package that the ADO file belongs to." "dataset_file_obj" yes "deployment_obj,deploy_dataset_obj,ado_filename" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTDP" "deployment" "gst_deployment" yes "" 4627.24 "deployment_description" "" "This table defines an instance of a deployment package, from a particular site. Records in this table may be manually created for the curent site, or may be imported as part of loading a deployment package from an external site." "deployment_obj" yes "deploy_package_obj,originating_site_number" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTEL" "extract log" "gst_extract_log" yes "" 1004924403.09 "extract_log_description" "" "Each time a data extract report is run, an entry is created in this file. The main intention is to track the completion of extract procedures so that report formatting procedures can be initiated where required.

In the event that an extract log record is deleted, then any document produced records associated with the extract should be cascade deleted, providing that the print date has not been set - in order to tidy up the data." "extract_log_obj" yes "extract_log_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTER" "error log" "gst_error_log" yes "" 1004924402.09 "" "" "This table holds a list of errors generated either from business logic or user interface code.

The table will be periodically archived to ensure it does not get too huge.

The data in the table will be fed direct from the user interface, and periodically fed by the business logic error file which will be a flat file due to the fact that we cannot write direct to this table as the write would form part of the transaction being undone.." "error_log_obj" yes "error_group,error_number,error_log_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTPH" "password history" "gst_password_history" yes "" 1004924404.09 "" "" "This table keeps a history of previous passwords used by users. It is used for audit purposes, and preventing users using the same password within a given time period, e.g. 1 year." "password_history_obj" yes "password_history_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTRL" "release version" "gst_release_version" yes "" 3000049867.09 "" "" "This table records the record versions that make up a release. 

When creating a new release, a gst_release_version record must be created for every gst_record_version, marking the current version number of all data as of this release.

This can then be used to determine what data needs to be deployed between releases, i.e. what data has been modified between the releases by checking for matching version numbers in the gst_release_version table.
" "release_version_obj" yes "release_version_obj" 4 "_" ? no no "ICFDB" "" "" "" no
"GSTRV" "record version" "gst_record_version" yes "" 1004927721.09 "" "" "This table provides the means for identifying when static data is changed and needs to be deployed. 

When an item of data on a record changes, the replication trigger on the table will check if the version_data flag on the gsc_entity_mnemonic table is switched on. 

If the flag is on, either a record is written to this table or an existing record in the table is updated to indicate that the data has changed by incrementing the version_number_seq and resetting date, time and user. 

This table is checked every time the deployment data is written to ensure that all data that matches the deployment criteria is written out.

Basically any records with a version_number_seq greater than 0 has been changed locally and potentially needs to be deployed. Once an import is done for a record, the version_number_seq is set back to 0 indicating the data matches that since the last import and has not been modified since.

When importing data, the import_version_number_seq is used as a validity check and if this number does not match the import_version_number_seq of the data being imported or the current version_number_seq does not match, there is a potential conflict.
" "record_version_obj" yes "record_version_obj" 4 "_" ? no no "ICFDB" "" "" "" yes
"GSTSS" "session" "gst_session" yes "" 3000003279.09 "" "" "This table records a session and is only applicable for the duration of a session. Its purpose is to be able to record session activity and manage the context for the session in the child table gsm_server_context. The session id field from gsm_server_context has transferred to this table, so it only exists in one place for the session, and the object id for the session record is rather carried down onto the individual context records. This facilitates efficiently fixing the context id in the event a session is dropped and reconnected, thereby restoring context for the new session from the old session. For the Appserver, a record will be created in this table at connection time and checked / updated in the activate procedure.
This table must not have a write trigger so that it can be updated as efficiently as possible.
The information in this table is all client related, and in the case of a WebSpeed Agent, the agent is also the client.
" "session_obj" yes "session_id" 4 "_" ? no no "ICFDB" "" "" "" yes
"RYCAP" "attribute group" "ryc_attribute_group" yes "" 1004924439.09 "attribute_group_name" "" "This table facilitates the logical grouping of attributes to simplify their use, e.g. geometry, statusbar, etc. The primary use of this table is make the presentation of the attributes to the user more effective and usable. It is likely we could use a tree view, with attribute groups as a node and pressing plus on the group, showing all attributes within that group.

The attribute group is therefore for design time only and serves no purpose at runtime.
" "attribute_group_obj" yes "attribute_group_name" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCAT" "attribute" "ryc_attribute" yes "" 1004924438.09 "" "" "This table defines the attributes that may be allocated to objects, e.g. size, position, window title, query, where clause, etc. They are used to defined the properties of dynamic objects, plus to dynamically alter the behaviour of static objects.

Certain attributes are required for the application to function correctly and these will be set to system owned to prevent accidental deletion. Only users that are classified as able to maintain system owned information may manipulate this data. In many (most) cases, the actual attribute label will need to match to a valid Progress supported attribute.

Due to the powerful feature of allowing attributes to be defined at various levels, most dynamic data about smartobjects will utilise attributes.

Example areas that we will utilise attributes for include browser query, sort order and where clauses, container window titles, which window to run based on various button actions in a browser, e.g. add, modify, view, etc., status bar configuration, page enabling and disabling, field enabling and disabling by object instance, whether toolbar items are included in the menu, etc.
" "attribute_obj" yes "attribute_label" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCAV" "attribute value" "ryc_attribute_value" yes "" 1004924441.09 "" "" "This entity associates attributes with object types, smartobjects, and smartobject instances, and specifies the value of the attribute in the appropriate native data type or character if a native data type is not available for the data type.

The list of attribute values defined for the object type (class) must be complete, and unless an attribute is defined at the class level, it will not be available to be set within a subclass. Attribute values are not cascaded down to subclassess and entries will only exist at subclass levels for overrides. To read all the attribute values for an object, attributes for parent classes must also be read.

Records will then only exist for subclassess in the event the value has been specifically overridden for that subclass.

When creating entries in this table for attributes associated with an object type, then the smart object and instance will be 0.

When creating entries in the table for a smartobject, we will also populate the object type field to avoid having 0 in the key. Likewise when creating attributes for an object instance, we will populate the object type and the smartobject. This ensures effective use of the alternate keys.

Note: We must be careful when looking for attributes associated with an object type to ensure we look for the specific object type and 0 values for the smartobject and instance fields.

Where multiple rendering engines are supported and used, the render type object id adds another dimension to the possible attribute values.

It is possible to specify a specific rendering engine type for attributes at the class, master and instance levels. If an attribute is specified at the class level for a specific rendering engine type, and not for a 0 rendering engine type, then that attribute will only ever be used for the specific rendering engine type and will not apply across all rendering engines.
" "attribute_value_obj" yes "object_type_obj,smartobject_obj,object_instance_obj,attribute_label,container_smartobject_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCCR" "customization result" "ryc_customization_result" yes "" 3000003341.09 "customization_result_desc" "" "The table is required to store possible customization codes as a result of some level of customization. Many types of customization exist, including UI type customizations (e.g. HTML, DHTML, GUI), user category customizations, user customizations, company level customizations, etc as defined in the ryc_customization_type table.  To avoid confusion and to provide some level of control as to the use of the result codes, a result code must be for a specific customization type.

The table will basically contain a code and description field. Meaningful codes and descriptions should be used to avoid conflicting uses of result codes. The table is also joined to the customization type to identify which type of customization the result code is for. 

For user level customizations, example result codes could be individual user login names, e.g. Bruce, Anthony, Don, etc. Alternatively the customization results could be defined rather by job function, e.g. operator, administrator, clerk, etc. For UI type customizations, the result codes could be DHTML, HTML, GUI, PDA, etc. For language customizations, the result codes could be English, French, German, etc. Another possibility is customizations by user category, in which case the result codes would represent valid categories, e.g. data capturer.

This provides maximum flexibility as to how much customization is required. 
The customization types simply define the various levels of supported customization, and the result codes define the possible values each customization type can be. The customization result table could therefore be viewed as a list of valid values for a customization type.
Certain result codes, such as supported UI type customizations will be provided as part of the framework. These result codes will be defined with a system owned flag set to YES, and maintenance of these codes will be restricted to users authorized to maintain system data. Care should be taken when defining these framework supplied result codes to avoid potential conflicts with result codes used by Dynamics applications.
" "customization_result_obj" yes "customization_result_code" 4 "_" ? no no "ICFDB" "" "" "" yes
"RYCCY" "customization type" "ryc_customization_type" yes "" 3000003349.09 "customization_type_desc" "" "" "customization_type_obj" yes "customization_type_code" 4 "_" ? no no "ICFDB" "" "" "" yes
"RYCLA" "layout" "ryc_layout" yes "" 1004924445.09 "layout_name" "" "This table defines the available page layouts for pages on smartfolder windows, e.g. 1 browser with 1 toolbar underneath, n viewers above each other, 2 side by side viewers, 2 side by side browsers, etc.

It also defines the available frame layouts for objects on a frame, e.g. 1 column, 2 columns, etc.

The purpose of this table is to specify the program which is responsible for the layout when the window / frame  is construted or resized.

As of V2, we only really support relative layouts which are layout code 6.
" "layout_obj" yes "layout_name" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCOI" "object instance" "ryc_object_instance" yes "" 1004924446.09 "instance_description" "" "This is a running instance of an object on a container. This facilitates the allocation of specific attributes, links, and page numbers, etc. for the specific instance of an object.

The instance name must be unique within a container as this is used to manage and locate instances of objects on a container, and for applying customizations to the same instance, etc.

This table also defines which page within a container the instance appears on, and the order of the objects within a page - where applicable, i.e. for paged containers.

" "object_instance_obj" yes "object_instance_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCPA" "page" "ryc_page" yes "" 1004924447.09 "" "" "This table defines the actual pages in a container. All containers must at least have one page, which is page 0 and is always displayed. All objects on page 0 are always displayed. If there are no other pages, then no tab folder is visualised.

Example pages could be Page 1, Page 2, Customer Details, etc." "page_obj" yes "container_smartobject_obj,page_reference" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCRE" "relationship" "ryc_relationship" yes "" 9385.24 "relationship_description" "" "This table stores relationship information for tables in the Dynamics repository and application databases built using Dynamics.

Multiple relationships can exist between the same parent and child table if required, so one of these must be flagged as the primary relationship to use initially when joining between the two tables.

The relationship reference field is unique so that it can be referenced in code if required, where multiple possible relationships exists and application functionality depends on the relationship. Where the relationship reference is irrelevant, it can be automatically generated using the Dynamics sequences.

The attributes about the relationship map closely with the attributes supported by ERWin from Computer Associates.

The fields used to join the tables in the relationship are specified in the child table ryc_relationship_field.

The contents of this table should be automatically populated from information exported from a case tool such as ERwin, to make synchronization of changes as automated as possible.

This table, once populated, can be used to support generic application functionality such as automatic object generation, referential integrity trigger code, etc.

It is envisaged that at some stage in the future, the information in these tables will be replaced with support for relationships in the core language meta schema.
" "relationship_obj" yes "relationship_reference" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCRF" "relationship field" "ryc_relationship_field" yes "" 9423.24 "parent_table_name" "" "This table defines the fields used to join the two tables defined in the ryc_relationship table that this table is a child of. Multiple field joins are supported, as well as rolenamed foreign keys where the field names in the two tables do not match.

The join sequence determines the order to reference the fields when constructing a dynamic where clause to join the tables.

When joining to some tables, additional constant values for fields in the child table or parent table may need to be specified and this functionality is supported. 

An example of this in the Dynamics repository is when joining from the gsc_object_type table to the ryc_attribute_value table, where there is a single field from the parent table, the object_type_obj, but we must additionally specify a 0 value for other fields, eg. container_smartobject_obj, smartobject_obj and object_instance_obj. This means that when using constant values, the child or the parent field may be left blank.



" "relationship_field_obj" yes "relationship_obj,join_sequence" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCRI" "ri default" "ryc_ri_default" yes "" 9443.24 "" "" "This table defines the default referential integrity (RI) rules to apply when manually maintaining relationships in the ryc_relationship table.

The rules in this table will be used to default the parent and child actions based on the value of the identifying_relationship and nulls_allowed fields.

The standard set of RI defaults used by Dynamics are as follows:

For identifying and non-identifying but will no nulls the defaults are:
Child Delete = None
Child Insert = Restrict
Child Update = Restrict
Parent Delete = Restrict
Parent Insert = None
Parent Update = Restrict

For non-indentifying but with nulls allowed the defaults are:
Child Delete = None
Child Insert = Set Null
Child Update = Set Null
Parent Delete = Set Null
Parent Insert = None
Parent Update = Set Null

These are usually correct apart from the need to sometimes change the delete rules for the parent to cascade, and soemtimes even when a relationship allows nulls, you still want a restrict rule rather than a set null rule.
" "ri_default_obj" yes "relationship_type,action_type" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCRT" "render type" "ryc_render_type" yes "" 3000049906.09 "render_type_description" "" "This table defines the supported rendering engines, e.g. e.g. WEB, GUI, HTML, B2C, .NET, XML, etc. 

It is joined into the gst_session table to identify for a session which rendering engine is active for that session.

The main purpose of this table is to optionally join into the ryc_attribute_value table and ryc_ui_event table to provide an ability to override attribute values and events for different rendering engines at the class, master and instance level. The render type offers another dimension of customization capability specifically for rendering engines.

This also supports the ability to identify certain attributes and events that are only applicable to specific rendering engines, as well as the ability to override the values of common events and attributes across rendering engines." "render_type_obj" yes "render_type_code" 4 "_" ? no no "ICFDB" "" "" "" no
"RYCSL" "supported link" "ryc_supported_link" yes "" 1004924454.09 "" "" "This table defines the supported smartlinks for the various type of smartobjects, and whether the link can be a source, target, or both.

User defined links should not be set-up in this table. This table is purely to ensure that when linking objects on containers, only valid system links are used, plus user defined links. It is merely a developer aid.

Not all types of smartobjects support links, in which case there will be no entries in this table for them." "supported_link_obj" yes "object_type_obj,smartlink_type_obj" 4 "_" ? no yes "ICFDB" "" "" "" yes
"RYCSM" "smartlink" "ryc_smartlink" yes "" 1004924449.09 "link_name" "" "This table defines the actual smartlinks between objects on a container, to facilitate object communication. The link name may be user defined, or automatically copied from the smartlink type for system supported links.

If the source object instance is not specified, then the source s assumed to be the container. Likewise if the target object instance is not specified, then the target is assumed to be the container.

Example links would be a tableio link between a smartbrowser and a smarttoolbar, a record link between a smartbrowser and a smartviewer, etc." "smartlink_obj" yes "container_smartobject_obj,source_object_instance_obj,link_name,target_object_instance_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCSO" "smartobject" "ryc_smartobject" yes "" 1004924451.09 "object_description" "" "This table represents every object known to the repository, whether static or dynamic. All objects that can be run should be registered in the repository, including all visual objects, business logic, etc. Images for buttons, etc. should also be registered.

The only files not registered in the repository are include files.

Having the files registered allows them to be added as instances to containers, added to menus, have security applied to them, run them as part of flows and events, automate deployment of them, etc.

Many child tables exist to further define an object, and which tables apply depend on the object type. For example, information regarding links, pages, instances, etc. only pertain to objects that are containers. Even with containers, not all tables may apply, as viewers, browsers, and sdo's are containers for datafields but do not have the concept of pages, only window containers have pages, links, etc.

Certain object properties are only applicable to physical objects. Previously this table was broken into two, and th second table, gsc_object used to define physical properties. This was removed in V2 to improve performance and resolve many issues associated with this, hence some redundant fields in certain object types.

For versioning to work, we have turned off RI that would have prevented an object being deleted if it is used on a container - this is to allow imports and object assignments to work. This RI must therefore be manually coded where required.

We turned off the automatic delete cascade of smartobject attributes as it was also deleting attributes for instances of the smartobject when we did not want it to. Added a specific delete trigger customisation that rather joined on the primary_smartobject_obj in the attribute table when deleting attributes, to ensure only attributes for the smartobject were deleted, not also instance attributes.

This table optionally supports customization using custom result codes.The unique key to this table is made up of the object filename and a result code, allowing the same object name to exist with multiple result codes, each custom object containing what behaviour has been added or overridden. The object with a 0 result code is the master default object, and this must always exist.

In this way, any of the fields on this table, plus information in tables where this is the parent may be customized by result code. Tools support for this however may be limited initially.

Whenever reading a smartobject based on the filename, the result code must also be specified, using 0 if looking for the master.

A recursive join with a rolename of extends_smartobject_obj has been added to this table to support inherritance. This functionality however as of V2 has not been implemented into the framework. The intention is to allow objects to inherit from (extend) other objects, therefore facilitating changes to master or template objects being cascaded down to subclasses or instances, by reading up the class structure.

For V2, the inherittance functionality has just been added at the object type level." "smartobject_obj" yes "object_filename,customization_result_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCST" "smartlink type" "ryc_smartlink_type" yes "" 1004924450.09 "link_name" "" "This table defines the supported smart links available for linking objects on containers for object communication purposes.

Example links include page, container, update, commit, tableio, etc.

The main purpose of this table is to provide a valid list of smart links to choose from when building generic containers. Additional user defined smart links may be implemented by defining a user defined link.

The actual link name will be cascaded down onto the smartlink table where this is not a user defined link.

The supported link table will be used to highlight which are the expected links between any two smartobjects.
" "smartlink_type_obj" yes "link_name" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYCUE" "ui event" "ryc_ui_event" yes "" 1007600043.08 "event_name" "" "This entity stores information about UI events for a smartobject. It works very similar to the ryc_attribute_value table in that UI events can be associated with object types, smartobjects, and smartobject instances.

This allows the attachment of UI events to dynamic objects.

When creating entries in this table for events associated with an object type, then the smart object and instance will be 0.

When creating entries in the table for a smartobject, we will also populate the object type field to avoid having 0 in the key. Likewise when creating events for an object instance, we will populate the object type and the smartobject. This ensures effective use of the alternate keys.

Note: We must be careful when looking for events associated with an object type to ensure we look for the specific object type and 0 values for the smartobject and instance fields.

Events are not cascaded down to subclassess and entries will only exist at subclass levels for overrides. To read all the events for an object, events for parent classes must also be read.

Where multiple rendering engines are supported and used, the render type object id adds another dimension to the possible events.

It is possible to specify a specific rendering engine type for events at the class, master and instance levels. If an event is specified at the class level for a specific rendering engine type, and not for a 0 rendering engine type, then that event will only ever be used for the specific rendering engine type and will not apply across all rendering engines.
" "ui_event_obj" yes "object_type_obj,smartobject_obj,object_instance_obj,event_name,container_smartobject_obj" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYMCZ" "customization" "rym_customization" yes "" 3000004717.09 "" "" "This table captures the actual customization results for the various supported types of customization as defined in the ryc_customization_type table.

This table is joined from the ryc_customization_type table with a mandatory join to define the type of customization. It contains a customization_reference field as part of the unique key to store the value for the customization according to the type. For example, if this was a user level customization, then the reference field would contain a specific users login code. If this was a UI type customization, then the reference field would contain the value of a UI type, e.g. HTML, GUI, etc.

This differs from the values in the customization result table. The customization result table is a list of valid value result codes for the customization type. This table represents actual values that can be checked at runtime with the appropriate api and the values may differ to the result code values. The result code values are reusable.

For example, one customization type is user customization. In this customization table we could have a record for each user with the reference pointing at the user login name, e.g. Anthony, john, bruce, etc. The api specified for the customization type would be run to find the current user and lookup in this table what the specified result code is for the user. The result code for Anthony could be manager, and John could also point at the same result code, but Bruce may point at result code engineer. Note the possible reuse of result codes and the difference between the result code values and the customization references.

The table stores the result for the customization via a join to the customization result table, identifying the result code to use for this specific customization.
These tables then provide maximum flexibility for customization possibilities.
As stated previously, the resultant result codes for a session will be evaluated after authentication and made available to the session.

When reading from tables that support customization, e.g. the smartobject and related tables, the appropriate record will be read with a matching result code of the highest priority level, if any matching customizations exist, otherwise the default record will be used.

A generic tool will need to be developed to capture these customizations.
" "customization_obj" yes "customization_type_obj,customization_reference" 4 "_" ? no no "ICFDB" "" "" "" yes
"RYMDV" "data version" "rym_data_version" yes "" 1004924458.09 "" "" "This table facilitates the generic storage of data version numbers without having to add a specific version number field to any tables that require version control.

This will definitely be used in the context of versioning smartobjects, but may also be used to record a version number for any data, e.g. menu items, help, etc.

The update of this table will be automated by the version control procedures if they are being used to control maintenance of the data.

This information must be made available generically to a help about window in the context of smartobject versioning.

The version number is the version number as at the time written by the versioning procedures. The data may have been subsequently changed by the user outside of the version control procedures, which is a situation we cannot generically hande.

" "data_version_obj" yes "related_entity_mnemonic,related_entity_key" 4 "_" ? no no "ICFDB" "" "" "" yes
"RYMWT" "wizard tree" "rym_wizard_tree" yes "" 1007600054.08 "object_description" "" "This table captures wizard responses for the creation / modification of a standard ICF Dynamic TreeView Controller object.

It is used to forward engineer the object into the full Repository, generating all appropriate smartobject instances and attributes. Many assumptions are made regarding the look and feel of a standard ICF TreeView Controller which significantly simplifies the data that must be captured.

More complex specific modifications to an object may be made using the standard Repository Maintenance options.

This table also facilitates generation of the object into different UI's, e.g. Java.
" "wizard_tree_obj" yes "object_name" 4 "_" ? yes yes "ICFDB" "" "" "" yes
"RYTDS" "dbupdate status" "ryt_dbupdate_status" yes "" 3000004791.09 "update_db_name" "" "This table audits what DCU updates have occurred, and more importantly controls the DCU update beyond completion of the DCU, plus allows it to be re-run / re-started as required.

We need to be able to control and automate what tasks to do as part of the DCU for a specific release, at what stage they should be run, whether each step completed successfully, the order of the steps, etc.

Certain tasks can only occur after the DCU has finished, but before anybody starts using the system and the tasks require a valid login to complete. Currently we have no way of controlling or automating this, which is the primary reason for the table. This table will significantly improve the load-n-go functionality within Dynamics and help prevent migration and deployment issues.

The DCU will update this table from the information in the .pfl file that the DCU uses as the source of the information for the DCU.
" "dbupdate_status_obj" yes "update_db_name,delta_version,file_type,file_name,update_when" 4 "_" ? no no "ICFDB" "" "" "" yes
"RYTTDATA" "ryttDataField" "ryttDataField" yes "" 14429.5498 "tClassName" "" "" "" no "" 0 "" ? no no "temp-db" "" "" "" no
"TTCLASSA" "ttClassAttribute" "ttClassAttribute" no "" 98371.48 "tClassName" "" "" "" no "tClassName,tAttributeLabel" 0 "" no no no "TEMP-DB" "" "" "" no
"TTSUPPOR" "ttSupportedLink" "ttSupportedLink" no "" 97893.48 "ClassName" "" "" "" no "ClassName,LinkName" 0 "" no no no "TEMP-DB" "" "" "" no
"TTUIEVEN" "ttUiEvent" "ttUiEvent" no "" 98122.48 "tClassName" "" "" "tSmartObjectObj" yes "" 0 "" no no no "TEMP-DB" "" "" "" no
.
PSC
filename=gsc_entity_mnemonic
records=0000000000128
ldbname=ICFDB
timestamp=2007/10/04-15:21:41
numformat=44,46
dateformat=mdy-1950
map=NO-MAP
cpstream=UTF-8
.
0000104660
