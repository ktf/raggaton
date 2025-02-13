import streamlit as st  
from langchain_community.document_loaders import PDFPlumberLoader  
from langchain_experimental.text_splitter import SemanticChunker  
from langchain_community.embeddings import HuggingFaceEmbeddings  
from langchain_community.vectorstores import FAISS  
from langchain_community.llms import Ollama  

# Streamlit file uploader  
uploaded_file = st.file_uploader("Upload a PDF file", type="pdf")  

docs = []
if uploaded_file:  
    # Save PDF temporarily  
    with open("temp.pdf", "wb") as f:  
        f.write(uploaded_file.getvalue())  

    # Load PDF text  
    loader = PDFPlumberLoader("temp.pdf")  
    docs = loader.load()  

# Split text into semantic chunks  
text_splitter = SemanticChunker(HuggingFaceEmbeddings())  
if docs:
    
    documents = text_splitter.split_documents(docs)  

# Generate embeddings  
    embeddings = HuggingFaceEmbeddings()  
    vector_store = FAISS.from_documents(documents, embeddings)  

# Connect retriever  
    retriever = vector_store.as_retriever(search_kwargs={"k": 3})  # Fetch top 3 chunks  

