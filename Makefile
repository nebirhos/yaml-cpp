CXX = g++
AR = ar
LIBRARY = libyaml-cpp.a
TEST    = yaml-cpp-test
OBJECTS = $(SOURCES:.cpp=.o)
CPPFLAGS += -Iinclude/ -Itest/
CXXFLAGS += -Wall

SOURCES = $(wildcard src/*.cpp)
TEST_SOURCES = $(wildcard test/*.cpp test/old-api/*.cpp)
TEST_OBJECTS = $(TEST_SOURCES:.cpp=.o)

all: $(LIBRARY)

test: $(TEST)

.cpp.o:
	$(CXX) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

$(LIBRARY): $(OBJECTS)
	$(AR) -cq $(LIBRARY) $(OBJECTS)
	ranlib $(LIBRARY)

$(TEST): $(LIBRARY) $(TEST_OBJECTS)
	$(CXX) -o $(TEST) $(TEST_OBJECTS) $(LIBRARY)

clean: clean-test
	rm -f $(LIBRARY) $(OBJECTS)

clean-test:
	rm -f $(TEST_OBJECTS) $(TEST)
