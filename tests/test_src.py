def test_1() -> None:
    """
    Test that the main function does not raise an AssertionError
    """
    from src.main import main

    main()

    assert True
