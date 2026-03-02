-- OHDSI-SQL / SqlRender compliant DDL
-- Unquoted identifiers
-- Parameter: @cdm_schema

-- GENOMIC_TEST
CREATE TABLE @cdm_schema.GENOMIC_TEST (
  genomic_test_id            INTEGER       NOT NULL,
  care_site_id               INTEGER       NOT NULL,
  genomic_test_name          VARCHAR(255)  NULL,
  genomic_test_version       VARCHAR(50)   NULL,
  reference_genome           VARCHAR(50)   NULL,
  sequencing_device          VARCHAR(50)   NULL,
  library_preparation        VARCHAR(50)   NULL,
  target_capture             VARCHAR(50)   NULL,
  read_type                  VARCHAR(50)   NULL,
  read_length                INTEGER       NULL,
  quality_control_tools      VARCHAR(255)  NULL,
  total_reads                INTEGER       NULL,
  mean_target_coverage       FLOAT         NULL,
  per_target_base_cover_100x FLOAT         NULL,
  alignment_tools            VARCHAR(255)  NULL,
  variant_calling_tools      VARCHAR(255)  NULL,
  chromosome_coordinate      VARCHAR(255)  NULL,
  annotation_tools           VARCHAR(255)  NULL,
  annotation_databases       VARCHAR(255)  NULL,
  CONSTRAINT PK_GENOMIC_TEST PRIMARY KEY (genomic_test_id)
);

ALTER TABLE @cdm_schema.GENOMIC_TEST
  ADD CONSTRAINT FK_GENOMIC_TEST_CARE_SITE
  FOREIGN KEY (care_site_id)
  REFERENCES @cdm_schema.CARE_SITE (care_site_id);

-- TARGET_GENE
CREATE TABLE @cdm_schema.TARGET_GENE (
  target_gene_id  INTEGER      NOT NULL,
  genomic_test_id INTEGER      NOT NULL,
  hgnc_id         VARCHAR(50)  NOT NULL,
  hgnc_symbol     VARCHAR(50)  NOT NULL,
  CONSTRAINT PK_TARGET_GENE PRIMARY KEY (target_gene_id)
);

ALTER TABLE @cdm_schema.TARGET_GENE
  ADD CONSTRAINT FK_TARGET_GENE_GENOMIC_TEST
  FOREIGN KEY (genomic_test_id)
  REFERENCES @cdm_schema.GENOMIC_TEST (genomic_test_id);

-- VARIANT_OCCURRENCE
CREATE TABLE @cdm_schema.VARIANT_OCCURRENCE (
  variant_occurrence_id    INTEGER       NOT NULL,
  procedure_occurrence_id  INTEGER       NOT NULL,
  specimen_id              INTEGER       NOT NULL,
  reference_specimen_id    INTEGER       NULL,
  target_gene1_id          VARCHAR(50)   NULL,
  target_gene1_symbol      VARCHAR(255)  NULL,
  target_gene2_id          VARCHAR(50)   NULL,
  target_gene2_symbol      VARCHAR(255)  NULL,
  reference_sequence       VARCHAR(50)   NULL,
  rs_id                    VARCHAR(50)   NULL,
  reference_allele         VARCHAR(255)  NULL,
  alternate_allele         VARCHAR(255)  NULL,
  hgvs_c                   VARCHAR(MAX)  NULL,
  hgvs_p                   VARCHAR(MAX)  NULL,
  variant_read_depth       INTEGER       NULL,
  variant_exon_number      INTEGER       NULL,
  copy_number              FLOAT         NULL,
  cnv_locus                VARCHAR(MAX)  NULL,
  fusion_breakpoint        VARCHAR(MAX)  NULL,
  fusion_supporting_reads  INTEGER       NULL,
  sequence_alteration      VARCHAR(MAX)  NULL,
  variant_feature          VARCHAR(MAX)  NULL,
  genetic_origin           VARCHAR(50)   NULL,
  genotype                 VARCHAR(50)   NULL,
  CONSTRAINT PK_VARIANT_OCCURRENCE PRIMARY KEY (variant_occurrence_id)
);

ALTER TABLE @cdm_schema.VARIANT_OCCURRENCE
  ADD CONSTRAINT FK_VARIANT_OCCURRENCE_PROCEDURE_OCCURRENCE
  FOREIGN KEY (procedure_occurrence_id)
  REFERENCES @cdm_schema.PROCEDURE_OCCURRENCE (procedure_occurrence_id);

ALTER TABLE @cdm_schema.VARIANT_OCCURRENCE
  ADD CONSTRAINT FK_VARIANT_OCCURRENCE_SPECIMEN
  FOREIGN KEY (specimen_id)
  REFERENCES @cdm_schema.SPECIMEN (specimen_id);

ALTER TABLE @cdm_schema.VARIANT_OCCURRENCE
  ADD CONSTRAINT FK_VARIANT_OCCURRENCE_REFERENCE_SPECIMEN
  FOREIGN KEY (reference_specimen_id)
  REFERENCES @cdm_schema.SPECIMEN (specimen_id);

-- VARIANT_ANNOTATION
CREATE TABLE @cdm_schema.VARIANT_ANNOTATION (
  variant_annotation_id INTEGER       NOT NULL,
  variant_occurrence_id INTEGER       NOT NULL,
  annotation_field      VARCHAR(MAX)  NOT NULL,
  value_as_string       VARCHAR(MAX)  NULL,
  value_as_number       FLOAT         NULL,
  CONSTRAINT PK_VARIANT_ANNOTATION PRIMARY KEY (variant_annotation_id)
);

ALTER TABLE @cdm_schema.VARIANT_ANNOTATION
  ADD CONSTRAINT FK_VARIANT_ANNOTATION_VARIANT_OCCURRENCE
  FOREIGN KEY (variant_occurrence_id)
  REFERENCES @cdm_schema.VARIANT_OCCURRENCE (variant_occurrence_id);

CREATE INDEX IX_VARIANT_OCCURRENCE_PROCEDURE 
ON @cdm_schema.VARIANT_OCCURRENCE (procedure_occurrence_id);

CREATE INDEX IX_VARIANT_ANNOTATION_VARIANT 
ON @cdm_schema.VARIANT_ANNOTATION (variant_occurrence_id);
