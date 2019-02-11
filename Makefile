# 
# Copyright (C) 2018 Intel Corporation
#
# SPDX-License-Identifier: BSD-3-Clause
# 
#

JAVAC = $(JAVA_HOME)/bin/javac
JAVA = $(JAVA_HOME)/bin/java
JAR = $(JAVA_HOME)/bin/jar
JAVADOC = $(JAVA_HOME)/bin/javadoc

JAVAFLAGS = -Xlint:unchecked -proc:none -XDenableSunApiLintControl

JAVA_SOURCE_DIR = src/main/java
PACKAGE_NAME = lib/llpl

TEST_DIR = src/test/java/$(PACKAGE_NAME)

TARGET_DIR = target
CLASSES_DIR = $(TARGET_DIR)/classes
TEST_CLASSES_DIR = $(TARGET_DIR)/test_classes

BASE_CLASSPATH = $(CLASSES_DIR):lib

ALL_JAVA_SOURCES = $(wildcard $(JAVA_SOURCE_DIR)/$(PACKAGE_NAME)/*.java)

ALL_TEST_SOURCES = $(addprefix $(TEST_DIR)/, \
	CopyMemoryTest.java \
	PersistentMemoryBlockTest.java \
	MemoryBlockCollectionTest.java \
	MemoryBlockFreeTest.java \
	MemoryBlockEqualityTest.java \
	MemoryBlockTest.java \
	MultipleHeapTest.java \
	MultipleTransactionalHeapTest.java \
	SetMemoryTest.java \
	TransactionTest.java \
	TransactionalMemoryBlockTest.java \
	UnboundedMemoryBlockTest.java \
	)

#	TransactionPerfTest.java \
#	DurablePerfTest.java \

ALL_TEST_CLASSES = $(addprefix $(TEST_CLASSES_DIR)/, $(notdir $(ALL_TEST_SOURCES:.java=.class)))
ALL_PERF_TEST_CLASSES = $(addprefix $(TEST_CLASSES_DIR)/, $(notdir $(ALL_PERF_TEST_SOURCES:.java=.class)))

EXAMPLES_DIR = src/examples
ALL_EXAMPLE_DIRS = $(wildcard $(EXAMPLES_DIR)/*)
#$(addprefix $(EXAMPLES_DIR)/, reservations employees)

all: sources examples testsources
sources: java
java: classes
docs: classes
	$(JAVADOC) -d  docs lib.llpl -sourcepath $(JAVA_SOURCE_DIR)
jar: sources
	$(JAR) cvf $(TARGET_DIR)/llpl.jar -C $(CLASSES_DIR) lib/ 		

examples: sources
	$(foreach example_dir,$(ALL_EXAMPLE_DIRS), $(JAVAC) $(JAVAFLAGS) -cp $(BASE_CLASSPATH):$(example_dir) $(example_dir)/*.java;)

testsources: sources
	$(JAVAC) $(JAVAFLAGS) -cp $(BASE_CLASSPATH):src -d $(TEST_CLASSES_DIR) $(TEST_DIR)/*.java;

clean: cleanex
	rm -rf target

cleanex:
	$(foreach example_dir,$(ALL_EXAMPLE_DIRS), rm -rf $(example_dir)/*.class;)

tests: $(ALL_TEST_CLASSES)
	$(foreach test,$^, $(JAVA) -ea -cp $(BASE_CLASSPATH):$(TEST_CLASSES_DIR):lib/jna-5.2.0.jar -Djava.library.path=/usr/local/lib $(PACKAGE_NAME)/$(notdir $(test:.class=));)

$(ALL_TEST_CLASSES): | $(TEST_CLASSES_DIR)

classes: | $(CLASSES_DIR) $(TEST_CLASSES_DIR) 
	$(JAVAC) $(JAVAFLAGS) -d $(CLASSES_DIR) -cp $(BASE_CLASSPATH):lib/jna-5.2.0.jar $(ALL_JAVA_SOURCES)

$(CLASSES_DIR):
	mkdir -p $(CLASSES_DIR)

$(TEST_CLASSES_DIR):
	mkdir -p $(TEST_CLASSES_DIR)
