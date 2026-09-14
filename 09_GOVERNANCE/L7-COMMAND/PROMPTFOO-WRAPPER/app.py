"""Promptfoo wrapper - Streamlit GUI with STATE"""
import streamlit as st
import json, sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from backend import run_eval

st.set_page_config(page_title="MICO RACE Generator", layout="wide")
st.title("MICO RACE Prompt Generator")
st.caption("L6 Application - Evaluation Harness")

with st.form("race"):
    st.subheader("RACE - Isi Perintah")
    col1, col2 = st.columns(2)
    with col1:
        rule = st.text_area("Aturan (Rule)", height=100)
        action = st.text_area("Tindakan (Action)", height=100)
    with col2:
        context = st.text_area("Konteks (Context)", height=100)
        expectation = st.text_area("Ekspektasi (Expectation)", height=100)

    st.subheader("STATE - Untuk Siapa dan Untuk Apa")
    col3, col4, col5 = st.columns(3)
    with col3:
        recipient = st.text_input("Untuk siapa?", value="Iswan pribadi")
    with col4:
        purpose = st.text_input("Untuk apa?", value="Uji pemahaman")
    with col5:
        depth = st.text_input("Kedalaman?", value="1 paragraf teknis")

    provider = st.selectbox("Penyedia", ["echo"])
    submitted = st.form_submit_button("Evaluasi Pelaksanaan")

if submitted:
    with st.spinner("Running..."):
        result = run_eval(rule, action, context, expectation, recipient, purpose, depth, provider)
    st.success("ID Eksekusi: " + result["run_id"])
    st.metric("Kode pengembalian", result["returncode"])
    if result.get("output"):
        stats = result["output"]["results"]["stats"]
        c1, c2, c3 = st.columns(3)
        c1.metric("Lulus", stats["successes"])
        c2.metric("Gagal", stats["failures"])
        c3.metric("Kesalahan", stats["errors"])
    st.info("Bukti: " + result.get("evidence_path", "-"))
    with st.expander("Hasil mentah"):
        st.json(result)
